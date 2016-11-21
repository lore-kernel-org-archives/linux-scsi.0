From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 11:23:03 +0200
Message-ID: <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35588 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbcKUJXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 04:23:05 -0500
Received: by mail-io0-f193.google.com with SMTP id h133so4996837ioe.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 01:23:05 -0800 (PST)
In-Reply-To: <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org

Hi,

The utility I mentioned is just a small program that I wrote to learn
more about the problem.

It is a very simple read16 with options for mmap and dxferp as null or other.

Here is the source code:

== cut here ==

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>

#include <getopt.h>
#include <unistd.h>
#include <fcntl.h>
#include <scsi/sg.h>
#include <sys/ioctl.h>
#include <sys/mman.h>


void* prepare_addr_fd(const char* devname, size_t block_size, int* fd,
int fmmap)
{
    void* addr = NULL;
    int sg_fd;

    if ((sg_fd = open(devname, O_RDWR)) < 0) {
        fprintf(stderr, "failed to open %s: %s\n", devname, strerror(errno));
        exit(1);
    }

    if (fmmap) {
        addr = mmap(NULL, block_size, (PROT_READ | PROT_WRITE),
MAP_SHARED, sg_fd, 0);
        if (addr == MAP_FAILED) {
            fprintf(stderr, "failed to mmap %s: %s\n", devname,
strerror(errno));
            exit(1);
        }
    }
    else {
        addr = valloc(block_size);
        if (!addr) {
            fprintf(stderr, "failed to allocate: %s\n", strerror(errno));
            exit(1);
        }
    }

    assert(fd != NULL);
    *fd = sg_fd;
    return addr;
}


void cleanup_addr_fd(void* addr, size_t size, int fd, int mmap)
{
    if (addr) {
        if (mmap)
            munmap(addr, size);
        else
            free(addr);
    }

    close(fd);
}


void prepare_read16_cdb(size_t lba, size_t block_count, unsigned char
scsi_cmd[])
{
    // initialize the scsi_cmd buffer
    //
    scsi_cmd[0] = (unsigned char)(0x88); /* READ 16 opcode */

    scsi_cmd[2] = (unsigned char)((lba >> 56) & 0xff);  /* lba */
    scsi_cmd[3] = (unsigned char)((lba >> 48) & 0xff);
    scsi_cmd[4] = (unsigned char)((lba >> 40) & 0xff);
    scsi_cmd[5] = (unsigned char)((lba >> 32) & 0xff);
    scsi_cmd[6] = (unsigned char)((lba >> 24) & 0xff);
    scsi_cmd[7] = (unsigned char)((lba >> 16) & 0xff);
    scsi_cmd[8] = (unsigned char)((lba >> 8) & 0xff);
    scsi_cmd[9] = (unsigned char)(lba & 0xff);

    scsi_cmd[10] = (unsigned char)((block_count >> 24) & 0xff); /*
block count */
    scsi_cmd[11] = (unsigned char)((block_count >> 16) & 0xff);
    scsi_cmd[12] = (unsigned char)((block_count >> 8) & 0xff);
    scsi_cmd[13] = (unsigned char)(block_count & 0xff);
}

void scsi_read_block(const char* device, size_t lba, int fmmap, int fmmap_bug)
{
    struct sg_io_hdr hdr;
    unsigned char cdb[16];
    unsigned char scsi_sense[96];
    int fd = 0;
    void* addr = NULL;

    memset(cdb, 0, sizeof cdb);
    memset(&hdr, 0, sizeof hdr);
    memset(scsi_sense, 0, sizeof scsi_sense);

    addr = prepare_addr_fd(device, 8192, &fd, fmmap);
    prepare_read16_cdb(lba, 1, cdb);

    hdr.interface_id    = 'S';
    hdr.dxfer_direction = SG_DXFER_FROM_DEV;
    hdr.iovec_count     = 0;
    hdr.dxfer_len       = 512;
    hdr.mx_sb_len       = sizeof scsi_sense;
    hdr.sbp             = scsi_sense;
    hdr.timeout         = 30000;
    hdr.pack_id         = 0;
    hdr.usr_ptr         = 0;
    hdr.cmdp            = cdb;
    hdr.cmd_len         = sizeof(cdb);

    if (fmmap) {
        hdr.flags = 4;

        // dxferp is null unless we want to recreate the bug
        if (fmmap_bug)
            hdr.dxferp = addr;
    }
    else {
        hdr.dxferp = addr;
    }

    if (ioctl(fd, SG_IO, &hdr) < 0) {
        fprintf(stderr, "ioctl failed: %s\n", strerror(errno));
        exit(1);
    }

    // pipe to od or hexdump
    //
    write(STDOUT_FILENO, addr, 64);

    cleanup_addr_fd(addr, 8192, fd, fmmap);
}

int main(int argc, char* argv[])
{
    const char* device = NULL;
    ssize_t lba = -1;
    int fmmap = 0;
    int fmmap_bug = 0;
    int opt;

    const char* help_str =
        "Usage: sg_mmap_read -d /dev/sgNNN -l <LBA> [-m -b]\n\n"
        "Use -m to use mmap IO, use -b to check if dxferp is ignored\n"
        "Redirect printing to od or hexdump\n";

    if (argc == 1) {
        puts(help_str);
        return 0;
    }

    while ((opt = getopt(argc, argv, "d:l:mbh")) != -1) {
        switch (opt) {
        case 'd':
            device = strdup(optarg);
            break;
        case 'l':
            lba = atol(optarg);
            break;
        case 'm':
            fmmap = 1;
            break;
        case 'b':
            fmmap_bug = 1;
            break;
        case 'h':
            puts(help_str);
            return 0;
        default:
            return 1;
        }
    }

    if (!device || lba == -1) {
        fprintf(stderr, "command line error: missing device or lba");
        return 1;
    }

    scsi_read_block(device, lba, fmmap, fmmap_bug);

    return 0;
}

2016-11-21 2:04 GMT+02:00 Laurence Oberman <loberman@redhat.com>:
>
>
> ----- Original Message -----
>> From: "Eyal Ben David" <bdeyal@gmail.com>
>> To: linux-scsi@vger.kernel.org
>> Sent: Sunday, November 20, 2016 11:02:49 AM
>> Subject: SG does not ignore dxferp (direct io + mmap)
>>
>> Hi all,
>>
>> We have some IO utility that perform the IOs using sg and direct io with
>> mmap.
>> Our current systems are Ubuntu 14.04, RHEL 6,7
>> The IO utility always set dxferp to either the address or mmap of
>> other allocation (valloc)
>> Setting dxferp was harmless since SG is supposed to ignore the address
>> if mmap IO is selected.
>> When porting to Ubuntu 16.04, we had a corruption problem - first byte
>> of a read task is always 0.
>> When setting dxferp as NULL the corruption does not occur any more.
>> This is a regression and not according to SCSI generic documentation.
>>
>> I wrote a small program that shows the change:
>>
>> Read indirect (no mmap), lba=0:
>> =======================
>> $ ./sg_mmap_read -d /dev/sg0 -l 0
>> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>
>> Read with mmap, lba=0, dxferp=NULL:
>> ============================
>> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m
>> 0000000 eb 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>
>> Read with mmap, lba=0, dxferp=address from mmap
>> ======================================
>> $ ./sg_mmap_read -d /dev/sg0 -l 0 -m -b
>> 0000000 00 63 90 10 8e d0 bc 00 b0 b8 00 00 8e d8 8e c0
>>
>> On the older systems all results are the same.
>>
>> Thanks for any answer!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Hello
>
> Given that we cannot see what your utility (sg_mmap_read) is doing, can we get the source for that or an strace of your test here.
> I am sure Doug will then be able to help you.
>
> Thanks
> Laurence
