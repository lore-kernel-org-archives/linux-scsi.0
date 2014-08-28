From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [RFC PATCH 10/10] scsi/trace: Use scsi_print_command trace
 point instead of printk
Date: Thu, 28 Aug 2014 10:40:32 +0900
Message-ID: <53FE8890.80403@hitachi.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115030.6768.91195.stgit@yuno-kbuild.novalocal> <53FDE859.1020800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53FDE859.1020800@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

(2014/08/27 23:16), Hannes Reinecke wrote:
> On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
>> Previous printk messages of SCSI command can be mixed into other printk
>> messages because multiple printk messages are output for it. To avoid the
>> problem, patch 4e64bb8d6 in Hannes' branch(*1) introduced a local buffer.
>> But using local buffers can induce stack overflow, so we want to solve
>> the
>> problem without local buffer if possible.
>>
>> trace_seq_printf can add log messages without local buffer, so we use it.
>>
>> Note:
>> We don't need constans.c any more.
>>
>> (*1)
>> http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/?h=logging
>>
>>
>>   - Result examples
>>
>> <Before> (printk)
>> sd 2:0:0:0: [sda] CDB: Read(10)
>>
>> <After>
>> scsi_print_command: host_no=2 channel=0 id=0 lun=0 [sda] CDB (Read(10))
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Doug Gilbert <dgilbert@interlog.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>   drivers/scsi/Makefile       |    2
>>   drivers/scsi/constants.c    |  425
>> -------------------------------------------
>>   drivers/scsi/scsi_trace.c   |  408
>> +++++++++++++++++++++++++++++++++++++++++
>>   include/scsi/scsi.h         |    8 +
>>   include/trace/events/scsi.h |   45 +++++
>>   5 files changed, 461 insertions(+), 427 deletions(-)
>>   delete mode 100644 drivers/scsi/constants.c
>>
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 5f0d299..c56f692 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -158,7 +158,7 @@ obj-$(CONFIG_SCSI_OSD_INITIATOR) += osd/
>>   # This goes last, so that "real" scsi devices probe earlier
>>   obj-$(CONFIG_SCSI_DEBUG)    += scsi_debug.o
>>
>> -scsi_mod-y            += scsi.o hosts.o scsi_ioctl.o constants.o \
>> +scsi_mod-y            += scsi.o hosts.o scsi_ioctl.o \
>>                      scsicam.o scsi_error.o scsi_lib.o
>>   scsi_mod-$(CONFIG_SCSI_DMA)    += scsi_lib_dma.o
>>   scsi_mod-y            += scsi_scan.o scsi_sysfs.o scsi_devinfo.o
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> deleted file mode 100644
>> index ce9ceb8..0000000
>> --- a/drivers/scsi/constants.c
>> +++ /dev/null
>> @@ -1,425 +0,0 @@
>> -/*
>> - * ASCII values for a number of symbolic constants, printing functions,
>> - * etc.
>> - * Additions for SCSI 2 and Linux 2.2.x by D. Gilbert (990422)
>> - * Additions for SCSI 3+ (SPC-3 T10/1416-D Rev 07 3 May 2002)
>> - *   by D. Gilbert and aeb (20020609)
>> - * Updated to SPC-4 T10/1713-D Rev 36g, D. Gilbert 20130701
>> - */
>> -
>> -#include <linux/blkdev.h>
>> -#include <linux/module.h>
>> -#include <linux/kernel.h>
>> -#include <asm/unaligned.h>
>> -
>> -#include <scsi/scsi.h>
>> -#include <scsi/scsi_cmnd.h>
>> -
>> -/* Commands with service actions that change the command name */
>> -#define SERVICE_ACTION_IN_12 0xab
>> -#define SERVICE_ACTION_OUT_12 0xa9
>> -#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
>> -#define SERVICE_ACTION_IN_16 0x9e
>> -#define SERVICE_ACTION_OUT_16 0x9f
>> -#define THIRD_PARTY_COPY_OUT 0x83
>> -#define THIRD_PARTY_COPY_IN 0x84
>> -
>> -
>> -
>> -#ifdef CONFIG_SCSI_CONSTANTS
>> -static const char * cdb_byte0_names[] = {
>> -/* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request
>> Sense",
>> -/* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
>> -        "Reassign Blocks",
>> -/* 08-0d */ "Read(6)", NULL, "Write(6)", "Seek(6)", NULL, NULL,
>> -/* 0e-12 */ NULL, "Read Reverse", "Write Filemarks", "Space", "Inquiry",
>> -/* 13-16 */ "Verify(6)", "Recover Buffered Data", "Mode Select(6)",
>> -        "Reserve(6)",
>> -/* 17-1a */ "Release(6)", "Copy", "Erase", "Mode Sense(6)",
>> -/* 1b-1d */ "Start/Stop Unit", "Receive Diagnostic", "Send Diagnostic",
>> -/* 1e-1f */ "Prevent/Allow Medium Removal", NULL,
>> -/* 20-22 */  NULL, NULL, NULL,
>> -/* 23-28 */ "Read Format Capacities", "Set Window",
>> -        "Read Capacity(10)", NULL, NULL, "Read(10)",
>> -/* 29-2d */ "Read Generation", "Write(10)", "Seek(10)", "Erase(10)",
>> -            "Read updated block",
>> -/* 2e-31 */ "Write Verify(10)", "Verify(10)", "Search High", "Search
>> Equal",
>> -/* 32-34 */ "Search Low", "Set Limits", "Prefetch/Read Position",
>> -/* 35-37 */ "Synchronize Cache(10)", "Lock/Unlock Cache(10)",
>> -        "Read Defect Data(10)",
>> -/* 38-3c */ "Medium Scan", "Compare", "Copy Verify", "Write Buffer",
>> -        "Read Buffer",
>> -/* 3d-3f */ "Update Block", "Read Long(10)",  "Write Long(10)",
>> -/* 40-41 */ "Change Definition", "Write Same(10)",
>> -/* 42-48 */ "Unmap/Read sub-channel", "Read TOC/PMA/ATIP",
>> -        "Read density support", "Play audio(10)", "Get configuration",
>> -        "Play audio msf", "Sanitize/Play audio track/index",
>> -/* 49-4f */ "Play track relative(10)", "Get event status notification",
>> -            "Pause/resume", "Log Select", "Log Sense", "Stop play/scan",
>> -            NULL,
>> -/* 50-55 */ "Xdwrite", "Xpwrite, Read disk info", "Xdread, Read track
>> info",
>> -            "Reserve track", "Send OPC info", "Mode Select(10)",
>> -/* 56-5b */ "Reserve(10)", "Release(10)", "Repair track", "Read
>> master cue",
>> -            "Mode Sense(10)", "Close track/session",
>> -/* 5c-5f */ "Read buffer capacity", "Send cue sheet", "Persistent
>> reserve in",
>> -            "Persistent reserve out",
>> -/* 60-67 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> -/* 68-6f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> -/* 70-77 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> -/* 78-7f */ NULL, NULL, NULL, NULL, NULL, NULL, "Extended CDB",
>> -        "Variable length",
>> -/* 80-84 */ "Xdwrite(16)", "Rebuild(16)", "Regenerate(16)",
>> -        "Third party copy out", "Third party copy in",
>> -/* 85-89 */ "ATA command pass through(16)", "Access control in",
>> -        "Access control out", "Read(16)", "Compare and Write",
>> -/* 8a-8f */ "Write(16)", "ORWrite", "Read attributes", "Write
>> attributes",
>> -            "Write and verify(16)", "Verify(16)",
>> -/* 90-94 */ "Pre-fetch(16)", "Synchronize cache(16)",
>> -            "Lock/unlock cache(16)", "Write same(16)", NULL,
>> -/* 95-99 */ NULL, NULL, NULL, NULL, NULL,
>> -/* 9a-9f */ NULL, NULL, NULL, "Service action bidirectional",
>> -        "Service action in(16)", "Service action out(16)",
>> -/* a0-a5 */ "Report luns", "ATA command pass through(12)/Blank",
>> -            "Security protocol in", "Maintenance in", "Maintenance out",
>> -        "Move medium/play audio(12)",
>> -/* a6-a9 */ "Exchange medium", "Move medium attached", "Read(12)",
>> -            "Play track relative(12)",
>> -/* aa-ae */ "Write(12)", NULL, "Erase(12), Get Performance",
>> -            "Read DVD structure", "Write and verify(12)",
>> -/* af-b1 */ "Verify(12)", "Search data high(12)", "Search data
>> equal(12)",
>> -/* b2-b4 */ "Search data low(12)", "Set limits(12)",
>> -            "Read element status attached",
>> -/* b5-b6 */ "Security protocol out", "Send volume tag, set streaming",
>> -/* b7-b9 */ "Read defect data(12)", "Read element status", "Read CD
>> msf",
>> -/* ba-bc */ "Redundancy group (in), Scan",
>> -            "Redundancy group (out), Set cd-rom speed", "Spare (in),
>> Play cd",
>> -/* bd-bf */ "Spare (out), Mechanism status", "Volume set (in), Read cd",
>> -            "Volume set (out), Send DVD structure",
>> -};
>> -
>> -struct value_name_pair {
>> -    int value;
>> -    const char * name;
>> -};
>> -
>> -static const struct value_name_pair maint_in_arr[] = {
>> -    {0x5, "Report identifying information"},
>> -    {0xa, "Report target port groups"},
>> -    {0xb, "Report aliases"},
>> -    {0xc, "Report supported operation codes"},
>> -    {0xd, "Report supported task management functions"},
>> -    {0xe, "Report priority"},
>> -    {0xf, "Report timestamp"},
>> -    {0x10, "Management protocol in"},
>> -};
>> -#define MAINT_IN_SZ ARRAY_SIZE(maint_in_arr)
>> -
>> -static const struct value_name_pair maint_out_arr[] = {
>> -    {0x6, "Set identifying information"},
>> -    {0xa, "Set target port groups"},
>> -    {0xb, "Change aliases"},
>> -    {0xc, "Remove I_T nexus"},
>> -    {0xe, "Set priority"},
>> -    {0xf, "Set timestamp"},
>> -    {0x10, "Management protocol out"},
>> -};
>> -#define MAINT_OUT_SZ ARRAY_SIZE(maint_out_arr)
>> -
>> -static const struct value_name_pair serv_in12_arr[] = {
>> -    {0x1, "Read media serial number"},
>> -};
>> -#define SERV_IN12_SZ ARRAY_SIZE(serv_in12_arr)
>> -
>> -static const struct value_name_pair serv_out12_arr[] = {
>> -    {-1, "dummy entry"},
>> -};
>> -#define SERV_OUT12_SZ ARRAY_SIZE(serv_out12_arr)
>> -
>> -static const struct value_name_pair serv_bidi_arr[] = {
>> -    {-1, "dummy entry"},
>> -};
>> -#define SERV_BIDI_SZ ARRAY_SIZE(serv_bidi_arr)
>> -
>> -static const struct value_name_pair serv_in16_arr[] = {
>> -    {0x10, "Read capacity(16)"},
>> -    {0x11, "Read long(16)"},
>> -    {0x12, "Get LBA status"},
>> -    {0x13, "Report referrals"},
>> -};
>> -#define SERV_IN16_SZ ARRAY_SIZE(serv_in16_arr)
>> -
>> -static const struct value_name_pair serv_out16_arr[] = {
>> -    {0x11, "Write long(16)"},
>> -    {0x1f, "Notify data transfer device(16)"},
>> -};
>> -#define SERV_OUT16_SZ ARRAY_SIZE(serv_out16_arr)
>> -
>> -static const struct value_name_pair pr_in_arr[] = {
>> -    {0x0, "Persistent reserve in, read keys"},
>> -    {0x1, "Persistent reserve in, read reservation"},
>> -    {0x2, "Persistent reserve in, report capabilities"},
>> -    {0x3, "Persistent reserve in, read full status"},
>> -};
>> -#define PR_IN_SZ ARRAY_SIZE(pr_in_arr)
>> -
>> -static const struct value_name_pair pr_out_arr[] = {
>> -    {0x0, "Persistent reserve out, register"},
>> -    {0x1, "Persistent reserve out, reserve"},
>> -    {0x2, "Persistent reserve out, release"},
>> -    {0x3, "Persistent reserve out, clear"},
>> -    {0x4, "Persistent reserve out, preempt"},
>> -    {0x5, "Persistent reserve out, preempt and abort"},
>> -    {0x6, "Persistent reserve out, register and ignore existing key"},
>> -    {0x7, "Persistent reserve out, register and move"},
>> -};
>> -#define PR_OUT_SZ ARRAY_SIZE(pr_out_arr)
>> -
>> -/* SPC-4 rev 34 renamed the Extended Copy opcode to Third Party Copy
>> Out.
>> -   LID1 (List Identifier length: 1 byte) is the Extended Copy found
>> in SPC-2
>> -   and SPC-3 */
>> -static const struct value_name_pair tpc_out_arr[] = {
>> -    {0x0, "Extended copy(LID1)"},
>> -    {0x1, "Extended copy(LID4)"},
>> -    {0x10, "Populate token"},
>> -    {0x11, "Write using token"},
>> -    {0x1c, "Copy operation abort"},
>> -};
>> -#define TPC_OUT_SZ ARRAY_SIZE(tpc_out_arr)
>> -
>> -static const struct value_name_pair tpc_in_arr[] = {
>> -    {0x0, "Receive copy status(LID1)"},
>> -    {0x1, "Receive copy data(LID1)"},
>> -    {0x3, "Receive copy operating parameters"},
>> -    {0x4, "Receive copy failure details(LID1)"},
>> -    {0x5, "Receive copy status(LID4)"},
>> -    {0x6, "Receive copy data(LID4)"},
>> -    {0x7, "Receive ROD token information"},
>> -    {0x8, "Report all ROD tokens"},
>> -};
>> -#define TPC_IN_SZ ARRAY_SIZE(tpc_in_arr)
>> -
>> -
>> -static const struct value_name_pair variable_length_arr[] = {
>> -    {0x1, "Rebuild(32)"},
>> -    {0x2, "Regenerate(32)"},
>> -    {0x3, "Xdread(32)"},
>> -    {0x4, "Xdwrite(32)"},
>> -    {0x5, "Xdwrite extended(32)"},
>> -    {0x6, "Xpwrite(32)"},
>> -    {0x7, "Xdwriteread(32)"},
>> -    {0x8, "Xdwrite extended(64)"},
>> -    {0x9, "Read(32)"},
>> -    {0xa, "Verify(32)"},
>> -    {0xb, "Write(32)"},
>> -    {0xc, "Write an verify(32)"},
>> -    {0xd, "Write same(32)"},
>> -    {0x8801, "Format OSD"},
>> -    {0x8802, "Create (osd)"},
>> -    {0x8803, "List (osd)"},
>> -    {0x8805, "Read (osd)"},
>> -    {0x8806, "Write (osd)"},
>> -    {0x8807, "Append (osd)"},
>> -    {0x8808, "Flush (osd)"},
>> -    {0x880a, "Remove (osd)"},
>> -    {0x880b, "Create partition (osd)"},
>> -    {0x880c, "Remove partition (osd)"},
>> -    {0x880e, "Get attributes (osd)"},
>> -    {0x880f, "Set attributes (osd)"},
>> -    {0x8812, "Create and write (osd)"},
>> -    {0x8815, "Create collection (osd)"},
>> -    {0x8816, "Remove collection (osd)"},
>> -    {0x8817, "List collection (osd)"},
>> -    {0x8818, "Set key (osd)"},
>> -    {0x8819, "Set master key (osd)"},
>> -    {0x881a, "Flush collection (osd)"},
>> -    {0x881b, "Flush partition (osd)"},
>> -    {0x881c, "Flush OSD"},
>> -    {0x8f7e, "Perform SCSI command (osd)"},
>> -    {0x8f7f, "Perform task management function (osd)"},
>> -};
>> -#define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
>> -
>> -struct sa_name_list {
>> -    int cmd;
>> -    const struct value_name_pair *arr;
>> -    int arr_sz;
>> -};
>> -
>> -static struct sa_name_list sa_names_arr[] = {
>> -    {VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
>> -    {MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
>> -    {MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
>> -    {PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
>> -    {PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
>> -    {SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
>> -    {SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
>> -    {SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
>> -    {SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
>> -    {SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
>> -    {THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
>> -    {THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
>> -    {0, NULL, 0},
>> -};
>> -#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
>> -
>> -static int scsi_opcode_sa_name(int cmd, int service_action,
>> -                   const char **sa_name)
>> -{
>> -    struct sa_name_list *sa_name_ptr = sa_names_arr;
>> -    const struct value_name_pair * arr = NULL;
>> -    int arr_sz, k;
>> -
>> -    for (k = 0; k < SA_NAME_LIST_SZ; ++k, ++sa_name_ptr) {
>> -        if (sa_name_ptr->cmd == cmd) {
>> -            arr = sa_name_ptr->arr;
>> -            arr_sz = sa_name_ptr->arr_sz;
>> -            break;
>> -        }
>> -    }
>> -    if (!arr)
>> -        return 0;
>> -
>> -    for (k = 0; k < arr_sz; ++k, ++arr) {
>> -        if (service_action == arr->value)
>> -            break;
>> -    }
>> -    if (k < arr_sz)
>> -        *sa_name = arr->name;
>> -
>> -    return 1;
>> -}
>> -#else
>> -static int scsi_opcode_sa_name(int cmd, int service_action,
>> -                   const char **sa_name)
>> -{
>> -    switch (cmd) {
>> -    case VARIABLE_LENGTH_CMD:
>> -    case MAINTENANCE_IN:
>> -    case MAINTENANCE_OUT:
>> -    case PERSISTENT_RESERVE_IN:
>> -    case PERSISTENT_RESERVE_OUT:
>> -    case SERVICE_ACTION_IN_12:
>> -    case SERVICE_ACTION_OUT_12:
>> -    case SERVICE_ACTION_BIDIRECTIONAL:
>> -    case SERVICE_ACTION_IN_16:
>> -    case SERVICE_ACTION_OUT_16:
>> -    case THIRD_PARTY_COPY_IN:
>> -    case THIRD_PARTY_COPY_OUT:
>> -        return 1;
>> -    }
>> -    return 0;
>> -}
>> -#endif /* CONFIG_SCSI_CONSTANTS */
>> -
>> -/* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
>> -static void print_opcode_name(struct scsi_device *sdev, const char
>> *prefix,
>> -                  unsigned char * cdbp, int cdb_len)
>> -{
>> -    int sa, cdb0, sa_valid;
>> -    const char * cdb_name = NULL, *sa_name = NULL;
>> -    const char * cdb_classifier = NULL;
>> -
>> -    cdb0 = cdbp[0];
>> -    if (cdb0 == VARIABLE_LENGTH_CMD) {
>> -#ifdef CONFIG_SCSI_CONSTANTS
>> -        const struct value_name_pair * arr = NULL;
>> -        int k;
>> -#endif
>> -        int len;
>> -
>> -        len = scsi_varlen_cdb_length(cdbp);
>> -        if (len < 10) {
>> -            sdev_printk(KERN_INFO, sdev,
>> -                    "short variable length command, "
>> -                    "len=%d ext_len=%d", len, cdb_len);
>> -            return;
>> -        }
>> -        sa = (cdbp[8] << 8) + cdbp[9];
>> -#ifdef CONFIG_SCSI_CONSTANTS
>> -        arr = variable_length_arr;
>> -        for (k = 0; k < VARIABLE_LENGTH_SZ; ++k, ++arr) {
>> -            if (sa == arr->value) {
>> -                sa_name = arr->name;
>> -                break;
>> -            }
>> -        }
>> -#endif
>> -        if (sa_name)
>> -            sdev_printk(KERN_INFO, sdev,
>> -                    "[%s] CDB: %s, in_cdb_len=%d, ext_len=%d",
>> -                    prefix, sa_name, len, cdb_len);
>> -        else
>> -            sdev_printk(KERN_INFO, sdev,
>> -                    "[%s] CDB: cdb[0]=0x%x, sa=0x%x, "
>> -                    "in_cdb_len=%d, ext_len=%d",
>> -                    prefix, cdb0, sa, len, cdb_len);
>> -        return;
>> -    }
>> -
>> -    if (cdb0 < 0xc0) {
>> -        cdb_classifier = NULL;
>> -#ifdef CONFIG_SCSI_CONSTANTS
>> -        cdb_name = cdb_byte0_names[cdb0];
>> -        if (!cdb_name)
>> -            cdb_classifier = " (reserved)";
>> -#endif
>> -    } else
>> -        cdb_classifier = " (vendor)";
>> -
>> -    sa = cdbp[1] & 0x1f;
>> -    sa_valid = scsi_opcode_sa_name(cdb0, sa, &sa_name);
>> -
>> -    if (!sa_valid) {
>> -        if (cdb_name)
>> -            sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s",
>> -                    prefix, cdb_name);
>> -        else
>> -            sdev_printk(KERN_INFO, sdev, "[%s] CDB: cdb[0]=0x%x%s",
>> -                    prefix, cdb0, cdb_classifier );
>> -    } else {
>> -        if (sa_name)
>> -            sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s",
>> -                    prefix, sa_name);
>> -        else if (cdb_name)
>> -            sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s, sa=0x%x",
>> -                    prefix, cdb_name, sa);
>> -        else
>> -            sdev_printk(KERN_INFO, sdev,
>> -                    "[%s] CDB: cdb[0]=0x%x, sa=0x%x",
>> -                    prefix, cdb0, sa);
>> -    }
>> -}
>> -
>> -void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
>> -              unsigned char *cdb, int cdb_len)
>> -{
>> -    char linebuf[128];
>> -    int i, linelen, remaining;
>> -
>> -    print_opcode_name(sdev, prefix, cdb, 0);
>> -    if (!cdb_len)
>> -        cdb_len = scsi_command_size(cdb);
>> -    /* print out all bytes in cdb */
>> -    remaining = cdb_len;
>> -    for (i = 0; i < cdb_len; i += 16) {
>> -        linelen = min(remaining, 16);
>> -        remaining -= 16;
>> -
>> -        hex_dump_to_buffer(cdb + i, linelen, 16, 1,
>> -                   linebuf, sizeof(linebuf), false);
>> -    }
>> -    sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n", prefix, linebuf);
>> -}
>> -EXPORT_SYMBOL(__scsi_print_command);
>> -
>> -void scsi_print_command(struct scsi_cmnd *cmd)
>> -{
>> -    const char *devname = cmd->request->rq_disk ?
>> -        cmd->request->rq_disk->disk_name : "scsi";
>> -
>> -    if (cmd->cmnd == NULL)
>> -        return;
>> -
>> -    print_opcode_name(cmd->device, devname, cmd->cmnd, cmd->cmd_len);
>> -}
>> -EXPORT_SYMBOL(scsi_print_command);
>> diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
>> index 60678d8..6761077 100644
>> --- a/drivers/scsi/scsi_trace.c
>> +++ b/drivers/scsi/scsi_trace.c
>> @@ -1237,6 +1237,414 @@ scsi_print_sense_hdr(struct scsi_device *sdev,
>> const char *name,
>>   }
>>   EXPORT_SYMBOL(scsi_print_sense_hdr);
>>
>> +/* Commands with service actions that change the command name */
>> +#define SERVICE_ACTION_IN_12 0xab
>> +#define SERVICE_ACTION_OUT_12 0xa9
>> +#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
>> +#define SERVICE_ACTION_IN_16 0x9e
>> +#define SERVICE_ACTION_OUT_16 0x9f
>> +#define THIRD_PARTY_COPY_OUT 0x83
>> +#define THIRD_PARTY_COPY_IN 0x84
>> +
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +static const char *cdb_byte0_names[] = {
>> +/* 00-03 */ "Test Unit Ready", "Rezero Unit/Rewind", NULL, "Request
>> Sense",
>> +/* 04-07 */ "Format Unit/Medium", "Read Block Limits", NULL,
>> +        "Reassign Blocks",
>> +/* 08-0d */ "Read(6)", NULL, "Write(6)", "Seek(6)", NULL, NULL,
>> +/* 0e-12 */ NULL, "Read Reverse", "Write Filemarks", "Space", "Inquiry",
>> +/* 13-16 */ "Verify(6)", "Recover Buffered Data", "Mode Select(6)",
>> +        "Reserve(6)",
>> +/* 17-1a */ "Release(6)", "Copy", "Erase", "Mode Sense(6)",
>> +/* 1b-1d */ "Start/Stop Unit", "Receive Diagnostic", "Send Diagnostic",
>> +/* 1e-1f */ "Prevent/Allow Medium Removal", NULL,
>> +/* 20-22 */  NULL, NULL, NULL,
>> +/* 23-28 */ "Read Format Capacities", "Set Window",
>> +        "Read Capacity(10)", NULL, NULL, "Read(10)",
>> +/* 29-2d */ "Read Generation", "Write(10)", "Seek(10)", "Erase(10)",
>> +        "Read updated block",
>> +/* 2e-31 */ "Write Verify(10)", "Verify(10)", "Search High", "Search
>> Equal",
>> +/* 32-34 */ "Search Low", "Set Limits", "Prefetch/Read Position",
>> +/* 35-37 */ "Synchronize Cache(10)", "Lock/Unlock Cache(10)",
>> +        "Read Defect Data(10)",
>> +/* 38-3c */ "Medium Scan", "Compare", "Copy Verify", "Write Buffer",
>> +        "Read Buffer",
>> +/* 3d-3f */ "Update Block", "Read Long(10)",  "Write Long(10)",
>> +/* 40-41 */ "Change Definition", "Write Same(10)",
>> +/* 42-48 */ "Unmap/Read sub-channel", "Read TOC/PMA/ATIP",
>> +        "Read density support", "Play audio(10)", "Get configuration",
>> +        "Play audio msf", "Sanitize/Play audio track/index",
>> +/* 49-4f */ "Play track relative(10)", "Get event status notification",
>> +        "Pause/resume", "Log Select", "Log Sense", "Stop play/scan",
>> +        NULL,
>> +/* 50-55 */ "Xdwrite", "Xpwrite, Read disk info", "Xdread, Read track
>> info",
>> +        "Reserve track", "Send OPC info", "Mode Select(10)",
>> +/* 56-5b */ "Reserve(10)", "Release(10)", "Repair track", "Read
>> master cue",
>> +        "Mode Sense(10)", "Close track/session",
>> +/* 5c-5f */ "Read buffer capacity", "Send cue sheet", "Persistent
>> reserve in",
>> +        "Persistent reserve out",
>> +/* 60-67 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> +/* 68-6f */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> +/* 70-77 */ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>> +/* 78-7f */ NULL, NULL, NULL, NULL, NULL, NULL, "Extended CDB",
>> +        "Variable length",
>> +/* 80-84 */ "Xdwrite(16)", "Rebuild(16)", "Regenerate(16)",
>> +        "Third party copy out", "Third party copy in",
>> +/* 85-89 */ "ATA command pass through(16)", "Access control in",
>> +        "Access control out", "Read(16)", "Compare and Write",
>> +/* 8a-8f */ "Write(16)", "ORWrite", "Read attributes", "Write
>> attributes",
>> +        "Write and verify(16)", "Verify(16)",
>> +/* 90-94 */ "Pre-fetch(16)", "Synchronize cache(16)",
>> +        "Lock/unlock cache(16)", "Write same(16)", NULL,
>> +/* 95-99 */ NULL, NULL, NULL, NULL, NULL,
>> +/* 9a-9f */ NULL, NULL, NULL, "Service action bidirectional",
>> +        "Service action in(16)", "Service action out(16)",
>> +/* a0-a5 */ "Report luns", "ATA command pass through(12)/Blank",
>> +        "Security protocol in", "Maintenance in", "Maintenance out",
>> +        "Move medium/play audio(12)",
>> +/* a6-a9 */ "Exchange medium", "Move medium attached", "Read(12)",
>> +        "Play track relative(12)",
>> +/* aa-ae */ "Write(12)", NULL, "Erase(12), Get Performance",
>> +        "Read DVD structure", "Write and verify(12)",
>> +/* af-b1 */ "Verify(12)", "Search data high(12)", "Search data
>> equal(12)",
>> +/* b2-b4 */ "Search data low(12)", "Set limits(12)",
>> +        "Read element status attached",
>> +/* b5-b6 */ "Security protocol out", "Send volume tag, set streaming",
>> +/* b7-b9 */ "Read defect data(12)", "Read element status", "Read CD
>> msf",
>> +/* ba-bc */ "Redundancy group (in), Scan",
>> +        "Redundancy group (out), Set cd-rom speed", "Spare (in), Play
>> cd",
>> +/* bd-bf */ "Spare (out), Mechanism status", "Volume set (in), Read cd",
>> +        "Volume set (out), Send DVD structure",
>> +};
>> +
>> +struct value_name_pair {
>> +    int value;
>> +    const char *name;
>> +};
>> +
>> +static const struct value_name_pair maint_in_arr[] = {
>> +    {0x5, "Report identifying information"},
>> +    {0xa, "Report target port groups"},
>> +    {0xb, "Report aliases"},
>> +    {0xc, "Report supported operation codes"},
>> +    {0xd, "Report supported task management functions"},
>> +    {0xe, "Report priority"},
>> +    {0xf, "Report timestamp"},
>> +    {0x10, "Management protocol in"},
>> +};
>> +#define MAINT_IN_SZ ARRAY_SIZE(maint_in_arr)
>> +
>> +static const struct value_name_pair maint_out_arr[] = {
>> +    {0x6, "Set identifying information"},
>> +    {0xa, "Set target port groups"},
>> +    {0xb, "Change aliases"},
>> +    {0xc, "Remove I_T nexus"},
>> +    {0xe, "Set priority"},
>> +    {0xf, "Set timestamp"},
>> +    {0x10, "Management protocol out"},
>> +};
>> +#define MAINT_OUT_SZ ARRAY_SIZE(maint_out_arr)
>> +
>> +static const struct value_name_pair serv_in12_arr[] = {
>> +    {0x1, "Read media serial number"},
>> +};
>> +#define SERV_IN12_SZ ARRAY_SIZE(serv_in12_arr)
>> +
>> +static const struct value_name_pair serv_out12_arr[] = {
>> +    {-1, "dummy entry"},
>> +};
>> +#define SERV_OUT12_SZ ARRAY_SIZE(serv_out12_arr)
>> +
>> +static const struct value_name_pair serv_bidi_arr[] = {
>> +    {-1, "dummy entry"},
>> +};
>> +#define SERV_BIDI_SZ ARRAY_SIZE(serv_bidi_arr)
>> +
>> +static const struct value_name_pair serv_in16_arr[] = {
>> +    {0x10, "Read capacity(16)"},
>> +    {0x11, "Read long(16)"},
>> +    {0x12, "Get LBA status"},
>> +    {0x13, "Report referrals"},
>> +};
>> +#define SERV_IN16_SZ ARRAY_SIZE(serv_in16_arr)
>> +
>> +static const struct value_name_pair serv_out16_arr[] = {
>> +    {0x11, "Write long(16)"},
>> +    {0x1f, "Notify data transfer device(16)"},
>> +};
>> +#define SERV_OUT16_SZ ARRAY_SIZE(serv_out16_arr)
>> +
>> +static const struct value_name_pair pr_in_arr[] = {
>> +    {0x0, "Persistent reserve in, read keys"},
>> +    {0x1, "Persistent reserve in, read reservation"},
>> +    {0x2, "Persistent reserve in, report capabilities"},
>> +    {0x3, "Persistent reserve in, read full status"},
>> +};
>> +#define PR_IN_SZ ARRAY_SIZE(pr_in_arr)
>> +
>> +static const struct value_name_pair pr_out_arr[] = {
>> +    {0x0, "Persistent reserve out, register"},
>> +    {0x1, "Persistent reserve out, reserve"},
>> +    {0x2, "Persistent reserve out, release"},
>> +    {0x3, "Persistent reserve out, clear"},
>> +    {0x4, "Persistent reserve out, preempt"},
>> +    {0x5, "Persistent reserve out, preempt and abort"},
>> +    {0x6, "Persistent reserve out, register and ignore existing key"},
>> +    {0x7, "Persistent reserve out, register and move"},
>> +};
>> +#define PR_OUT_SZ ARRAY_SIZE(pr_out_arr)
>> +
>> +/* SPC-4 rev 34 renamed the Extended Copy opcode to Third Party Copy
>> Out.
>> +   LID1 (List Identifier length: 1 byte) is the Extended Copy found
>> in SPC-2
>> +   and SPC-3 */
>> +static const struct value_name_pair tpc_out_arr[] = {
>> +    {0x0, "Extended copy(LID1)"},
>> +    {0x1, "Extended copy(LID4)"},
>> +    {0x10, "Populate token"},
>> +    {0x11, "Write using token"},
>> +    {0x1c, "Copy operation abort"},
>> +};
>> +#define TPC_OUT_SZ ARRAY_SIZE(tpc_out_arr)
>> +
>> +static const struct value_name_pair tpc_in_arr[] = {
>> +    {0x0, "Receive copy status(LID1)"},
>> +    {0x1, "Receive copy data(LID1)"},
>> +    {0x3, "Receive copy operating parameters"},
>> +    {0x4, "Receive copy failure details(LID1)"},
>> +    {0x5, "Receive copy status(LID4)"},
>> +    {0x6, "Receive copy data(LID4)"},
>> +    {0x7, "Receive ROD token information"},
>> +    {0x8, "Report all ROD tokens"},
>> +};
>> +#define TPC_IN_SZ ARRAY_SIZE(tpc_in_arr)
>> +
>> +static const struct value_name_pair variable_length_arr[] = {
>> +    {0x1, "Rebuild(32)"},
>> +    {0x2, "Regenerate(32)"},
>> +    {0x3, "Xdread(32)"},
>> +    {0x4, "Xdwrite(32)"},
>> +    {0x5, "Xdwrite extended(32)"},
>> +    {0x6, "Xpwrite(32)"},
>> +    {0x7, "Xdwriteread(32)"},
>> +    {0x8, "Xdwrite extended(64)"},
>> +    {0x9, "Read(32)"},
>> +    {0xa, "Verify(32)"},
>> +    {0xb, "Write(32)"},
>> +    {0xc, "Write an verify(32)"},
>> +    {0xd, "Write same(32)"},
>> +    {0x8801, "Format OSD"},
>> +    {0x8802, "Create (osd)"},
>> +    {0x8803, "List (osd)"},
>> +    {0x8805, "Read (osd)"},
>> +    {0x8806, "Write (osd)"},
>> +    {0x8807, "Append (osd)"},
>> +    {0x8808, "Flush (osd)"},
>> +    {0x880a, "Remove (osd)"},
>> +    {0x880b, "Create partition (osd)"},
>> +    {0x880c, "Remove partition (osd)"},
>> +    {0x880e, "Get attributes (osd)"},
>> +    {0x880f, "Set attributes (osd)"},
>> +    {0x8812, "Create and write (osd)"},
>> +    {0x8815, "Create collection (osd)"},
>> +    {0x8816, "Remove collection (osd)"},
>> +    {0x8817, "List collection (osd)"},
>> +    {0x8818, "Set key (osd)"},
>> +    {0x8819, "Set master key (osd)"},
>> +    {0x881a, "Flush collection (osd)"},
>> +    {0x881b, "Flush partition (osd)"},
>> +    {0x881c, "Flush OSD"},
>> +    {0x8f7e, "Perform SCSI command (osd)"},
>> +    {0x8f7f, "Perform task management function (osd)"},
>> +};
>> +#define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
>> +
>> +struct sa_name_list {
>> +    int cmd;
>> +    const struct value_name_pair *arr;
>> +    int arr_sz;
>> +};
>> +
>> +static struct sa_name_list sa_names_arr[] = {
>> +    {VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
>> +    {MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
>> +    {MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
>> +    {PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
>> +    {PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
>> +    {SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
>> +    {SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
>> +    {SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
>> +    {SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
>> +    {SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
>> +    {THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
>> +    {THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
>> +    {0, NULL, 0},
>> +};
>> +#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
>> +
>> +static int scsi_opcode_sa_name(int cmd, int service_action,
>> +                   const char **sa_name)
>> +{
>> +    struct sa_name_list *sa_name_ptr = sa_names_arr;
>> +    const struct value_name_pair *arr = NULL;
>> +    int arr_sz, k;
>> +
>> +    for (k = 0; k < SA_NAME_LIST_SZ; ++k, ++sa_name_ptr) {
>> +        if (sa_name_ptr->cmd == cmd) {
>> +            arr = sa_name_ptr->arr;
>> +            arr_sz = sa_name_ptr->arr_sz;
>> +            break;
>> +        }
>> +    }
>> +    if (!arr)
>> +        return 0;
>> +
>> +    for (k = 0; k < arr_sz; ++k, ++arr) {
>> +        if (service_action == arr->value)
>> +            break;
>> +    }
>> +    if (k < arr_sz)
>> +        *sa_name = arr->name;
>> +
>> +    return 1;
>> +}
>> +#else
>> +static int scsi_opcode_sa_name(int cmd, int service_action,
>> +                   const char **sa_name)
>> +{
>> +    switch (cmd) {
>> +    case VARIABLE_LENGTH_CMD:
>> +    case MAINTENANCE_IN:
>> +    case MAINTENANCE_OUT:
>> +    case PERSISTENT_RESERVE_IN:
>> +    case PERSISTENT_RESERVE_OUT:
>> +    case SERVICE_ACTION_IN_12:
>> +    case SERVICE_ACTION_OUT_12:
>> +    case SERVICE_ACTION_BIDIRECTIONAL:
>> +    case SERVICE_ACTION_IN_16:
>> +    case SERVICE_ACTION_OUT_16:
>> +    case THIRD_PARTY_COPY_IN:
>> +    case THIRD_PARTY_COPY_OUT:
>> +        return 1;
>> +    }
>> +    return 0;
>> +}
>> +#endif /* CONFIG_SCSI_CONSTANTS */
>> +
>> +const char *
>> +output_all_bytes(struct trace_seq *p, unsigned char *cdbp, int cdb_len)
>> +{
>> +    const char *ret = p->buffer + p->len;
>> +    int i;
>> +
>> +    if (!cdb_len)
>> +        cdb_len = scsi_command_size(cdbp);
>> +
>> +    for (i = 0; i < cdb_len; ++i)
>> +        trace_seq_printf(p, "%02x", cdbp[i]);
>> +
>> +    trace_seq_putc(p, 0);
>> +    return ret;
>> +}
>> +
>> +const char *
>> +print_opcode_name(struct trace_seq *p, unsigned char *cdbp, int cdb_len,
>> +          bool output_raw, int raw_len)
>> +{
>> +    int sa, cdb0, sa_valid;
>> +    const char *cdb_name = NULL, *sa_name = NULL;
>> +    const char *cdb_classifier = NULL;
>> +    const char *ret = p->buffer + p->len;
>> +
>> +    cdb0 = cdbp[0];
>> +    if (cdb0 == VARIABLE_LENGTH_CMD) {
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +        const struct value_name_pair *arr = NULL;
>> +        int k;
>> +#endif
>> +        int len;
>> +
>> +        len = scsi_varlen_cdb_length(cdbp);
>> +        if (len < 10) {
>> +            trace_seq_printf(p, "short variable length command, "
>> +                     "len=%d ext_len=%d", len, cdb_len);
>> +            goto out;
>> +        }
>> +        sa = (cdbp[8] << 8) + cdbp[9];
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +        arr = variable_length_arr;
>> +        for (k = 0; k < VARIABLE_LENGTH_SZ; ++k, ++arr) {
>> +            if (sa == arr->value) {
>> +                sa_name = arr->name;
>> +                break;
>> +            }
>> +        }
>> +#endif
>> +        if (sa_name)
>> +            trace_seq_printf(p, "CDB (%s, in_cdb_len=%d, "
>> +                     "ext_len=%d)", sa_name, len, cdb_len);
>> +        else
>> +            trace_seq_printf(p, "CDB (cdb[0]=0x%x, sa=0x%x, "
>> +                     "in_cdb_len=%d, ext_len=%d)",
>> +                     cdb0, sa, len, cdb_len);
>> +        goto out;
>> +    }
>> +
>> +    if (cdb0 < 0xc0) {
>> +        cdb_classifier = NULL;
>> +#ifdef CONFIG_SCSI_CONSTANTS
>> +        cdb_name = cdb_byte0_names[cdb0];
>> +        if (!cdb_name)
>> +            cdb_classifier = " (reserved)";
>> +#endif
>> +    } else
>> +        cdb_classifier = " (vendor)";
>> +
>> +    sa = cdbp[1] & 0x1f;
>> +    sa_valid = scsi_opcode_sa_name(cdb0, sa, &sa_name);
>> +
>> +    if (!sa_valid) {
>> +        if (cdb_name)
>> +            trace_seq_printf(p, "CDB (%s)", cdb_name);
>> +        else
>> +            trace_seq_printf(p, "CDB (cdb[0]=0x%x%s)",
>> +                     cdb0, cdb_classifier);
>> +    } else {
>> +        if (sa_name)
>> +            trace_seq_printf(p, "CDB (%s)", sa_name);
>> +        else if (cdb_name)
>> +            trace_seq_printf(p, "CDB (%s, sa=0x%x)", cdb_name, sa);
>> +        else
>> +            trace_seq_printf(p, "CDB (cdb[0]=0x%x, sa=0x%x)",
>> +                     cdb0, sa);
>> +    }
>> +
>> +out:
>> +    if (output_raw)
>> +        return output_all_bytes(p, cdbp, raw_len);
>> +    trace_seq_putc(p, 0);
>> +    return ret;
>> +}
>> +
>> +void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
>> +              unsigned char *cdb, int cdb_len)
>> +{
>> +    trace_scsi_print_command(sdev, prefix, cdb, 0, true, cdb_len);
>> +}
>> +EXPORT_SYMBOL(__scsi_print_command);
>> +
>> +void scsi_print_command(struct scsi_cmnd *cmd)
>> +{
>> +    const char *devname = cmd->request->rq_disk ?
>> +        cmd->request->rq_disk->disk_name : "scsi";
>> +
>> +    if (cmd->cmnd == NULL)
>> +        return;
>> +
>> +    trace_scsi_print_command(cmd->device, devname, cmd->cmnd,
>> +                 cmd->cmd_len, false, 0);
>> +}
>> +EXPORT_SYMBOL(scsi_print_command);
>> +
>>   static const char *
>>   scsi_dump_sense_buffer(struct trace_seq *p, const unsigned char
>> *buf, int len)
>>   {
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index 54ebf54..1680135 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -207,10 +207,16 @@ struct scsi_varlen_cdb_hdr {
>>       /* service specific data follows */
>>   };
>>
>> +static inline unsigned __scsi_varlen_cdb_length(u8
>> additional_cdb_length)
>> +{
>> +    return additional_cdb_length + 8;
>> +}
>> +
>>   static inline unsigned
>>   scsi_varlen_cdb_length(const void *hdr)
>>   {
>> -    return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length
>> + 8;
>> +    return __scsi_varlen_cdb_length(
>> +        ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length);
>>   }
>>
>>   extern const unsigned char scsi_command_size_tbl[8];
>> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
>> index 6d3543f..c50bade 100644
>> --- a/include/trace/events/scsi.h
>> +++ b/include/trace/events/scsi.h
>> @@ -449,6 +449,51 @@ TRACE_EVENT(scsi_print_sense,
>>             __entry->sense_len,  __entry->raw),
>>             __extd_sense(__entry->asc, __entry->ascq))
>>   );
>> +
>> +const char *
>> +print_opcode_name(struct trace_seq*, unsigned char*, int, bool, int);
>> +#define __opcode_name(cdbp, cdb_len, output_raw, raw_len)    \
>> +            print_opcode_name(p, cdbp, cdb_len, output_raw, raw_len)
>> +
>> +TRACE_EVENT(scsi_print_command,
>> +
>> +    TP_PROTO(struct scsi_device *sdev, const char *devname,
>> +         unsigned char *cdbp, int cdb_len, bool output_raw,
>> +         int raw_len),
>> +
>> +    TP_ARGS(sdev, devname, cdbp, cdb_len, output_raw, raw_len),
>> +
>> +    TP_STRUCT__entry(
>> +        __field( unsigned int,        host_no        )
>> +        __field( unsigned int,        channel        )
>> +        __field( unsigned int,        id        )
>> +        __field( unsigned int,        lun        )
>> +        __string(devname,        devname        )
>> +        __dynamic_array(unsigned char,    cdbp,
>> +                cdb_len ? cdb_len : scsi_command_size(cdbp))
>> +        __field( int,            cdb_len        )
>> +        __field( bool,            output_raw    )
>> +        __field( int,            raw_len        )
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->host_no    = sdev->host->host_no;
>> +        __entry->channel    = sdev->channel;
>> +        __entry->id        = sdev->id;
>> +        __entry->lun        = sdev->lun;
>> +        __assign_str(devname, devname);
>> +        memcpy(__get_dynamic_array(cdbp), cdbp,
>> +               cdb_len ? cdb_len : scsi_command_size(cdbp));
>> +        __entry->cdb_len    = cdb_len;
>> +        __entry->output_raw    = output_raw;
>> +        __entry->raw_len    = raw_len;
>> +    ),
>> +
>> +    TP_printk("host_no=%u channel=%u id=%u lun=%u [%s] %s",
>> +          __entry->host_no, __entry->channel, __entry->id, __entry->lun,
>> +          __get_str(devname), __opcode_name(__get_dynamic_array(cdbp),
>> +          __entry->cdb_len, __entry->output_raw, __entry->raw_len))
>> +);
>>   #endif /*  _TRACE_SCSI_H */
>>
>>   /* This part must be outside protection */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> No.
> constants.c is influenced by CONFIG_SCSI_CONSTANTS, and we should be
> keeping it that way.

OK, I'll do that. We'll use existing decoder in constants.c.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
