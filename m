From: vaughan <vaughan.cao@oracle.com>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Fri, 10 Jan 2014 16:09:03 +0800
Message-ID: <52CFAA9F.5010706@oracle.com>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26824 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAJIJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 03:09:38 -0500
In-Reply-To: <52CFA440.7030104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi <open-iscsi@googlegroups.com>, SCSI development list <linux-scsi@vger.kernel.org>, vaughan <vaughan.cao@oracle.com>

On 01/10/2014 03:41 PM, Mike Christie wrote:
> On 1/10/14 12:11 AM, vaughan wrote:
>> I haven't figure out why it's rejected with "bookmark invalid"(9)
>> reason, rather than "command not supported". IMO "bookmark invalid" is
>> used when minor protocol conflict such as final flag not set with
>> non-write command. However, I haven't find error of this kind in
>> report_opcode, so I guess it's not supported on the target.
>>
>
> Is it possible to get a wireshark/tcpdump trace? It does not have to
> be during boot. We just need to see what commands are sent and the
> response the target is returning.
>
> I forgot we know some microsoft iscsi target people. We can just email
> them with the trace to confirm what is going on with the target. The
> trace seems to be easier for them than them interpreting linux kernel
> logs.
I enabled debug_iscsi_tcp, here is a more detailed log in normal connection.
Does "conn error (1020)" mean it's target peer who disconnect the
connection at the same time of reject report_opcode?
If it is, I think iSCSI boot failure can't be avoided without disable
write_same check on OEL.

Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv in 52
bytes
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv read
0 bytes status 1
Dec 17 00:20:17 ol6u4gx64 kernel: sd 7:0:0:0: [sdc] Write Protect is off
Dec 17 00:20:17 ol6u4gx64 kernel: sd 7:0:0:0: [sdc] Mode Sense: 03 00 00 00
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0:
iscsi_sw_tcp_send_hdr_prep digest disabled
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0:
iscsi_sw_tcp_send_hdr_done Header done. Next segment size 0 total_size 0
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_xmit xmit
48 bytes
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv in 52
bytes
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv read
0 bytes status 1
Dec 17 00:20:17 ol6u4gx64 kernel: sd 7:0:0:0: [sdc] Got wrong page
Dec 17 00:20:17 ol6u4gx64 kernel: sd 7:0:0:0: [sdc] Assuming drive
cache: write through
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0:
iscsi_sw_tcp_send_hdr_prep digest disabled
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0:
iscsi_sw_tcp_send_hdr_done Header done. Next segment size 0 total_size 0
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_xmit xmit
48 bytes
Dec 17 00:20:17 ol6u4gx64 iscsid: Connection4:0 to [target:
iqn.1991-05.com.microsoft:test1, portal: 10.182.92.118,3260] through
[iface: default] is operational now
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv in 96
bytes
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: pdu (op 0x1 itt 0xa)
rejected. Reason code 0x9
Dec 17 00:20:17 ol6u4gx64 kernel: rejected iscsi cmd hdr:op 0x1, flags
0xc1, itt 0xa, data_length 512 CDB: a3 c 1 12 0 0 0 0 2 0 0 0 0 0 0 0
Dec 17 00:20:17 ol6u4gx64 kernel: iscsi_handle_reject: return 0
Dec 17 00:20:17 ol6u4gx64 kernel: __iscsi_complete_pdu:1165:
iscsi_handle_reject return 0
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_tcp_recv read
0 bytes status 1
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: iscsi_sw_sk_state_check
TCP_CLOSE|TCP_CLOSE_WAIT
Dec 17 00:20:17 ol6u4gx64 kernel: connection4:0: detected conn error (1020)
Dec 17 00:20:18 ol6u4gx64 iscsid: Kernel reported iSCSI connection 4:0
error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)

"rejected iscsi cmd hdr" line is added for debug as below.

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c

index d4b4b36..831786a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -993,7 +993,9 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
        struct iscsi_reject *reject = (struct iscsi_reject *)hdr;
        struct iscsi_hdr rejected_pdu;
+       struct iscsi_scsi_req rejected_scsi_req;
        int opcode, rc = 0;
+       int i;
 
        conn->exp_statsn = be32_to_cpu(reject->statsn) + 1;
 
@@ -1061,6 +1063,22 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
                                  "pdu (op 0x%x itt 0x%x) rejected. Reason "
                                  "code 0x%x\n", rejected_pdu.opcode,
                                  rejected_pdu.itt, reject->reason);
+               if (reject->reason == ISCSI_REASON_BOOKMARK_INVALID &&
+                   rejected_pdu.opcode == ISCSI_OP_SCSI_CMD) {
+                       memcpy(&rejected_scsi_req, data, sizeof(struct iscsi_hdr));
+                       printk("rejected iscsi cmd hdr:"
+                           "op 0x%x, flags 0x%x, itt 0x%x, data_length %u ",
+                       rejected_scsi_req.opcode,
+                       rejected_scsi_req.flags,
+                       rejected_scsi_req.itt,
+                       be32_to_cpu(rejected_scsi_req.data_length));
+                       printk("CDB:");
+                       for (i = 0; i < ISCSI_CDB_SIZE; i++) {
+                               printk(" %x", rejected_scsi_req.cdb[i]);
+                       }
+                       printk("\n");
+                       printk("%s: return %d\n", __FUNCTION__, rc);
+               }
                break;
        }
        return rc;

