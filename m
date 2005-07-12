From: rother-ml@gmx.de
Subject: =?ISO-8859-1?Q?qla2300_read_buffer_problems?=
Date: Tue, 12 Jul 2005 16:42:11 +0200 (MEST)
Message-ID: <24233.1121179331@www63.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:54420 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261489AbVGLOmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 10:42:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

we are encountering SAN problems. Twice or threetimes a minute we can
neither read nor write for up to five seconds from/to our LUs. After that
short periode, it catches up and resumes normally. The diagnostics in
SANsurfer (Read/Write Buffer Test) runs a few times successfully (approx.
8-10 times) and then tells us about a problem with the buffer cache: 
Info: DiagRWBufferTest:  Unable to send Pass-Thru READ_DATA_BUFF on target
(50-06-0e-80-00-c2-8a-03) (0x20000040) (SCSI check condition)
Info: DiagRWBufferTest: Sense Key:  0xe, asc:  0x1d, ascq:  0x0.

The numbers of "Link Failure", "Sync Loss" and "Signal Loss" are also
increasing.

After compiling the modules with almost every debug option the syslogd
notices the following lines:
qla2x00_scsi_passthru(18): entered.
qla2x00_get_ioctl_scrap_mem(18): inst=0 entered. size=348.
qla2x00_get_ioctl_scrap_mem(18): exiting. ret=0.
qla2x00_get_ioctl_scrap_mem(18): inst=0 entered. size=764.
qla2x00_get_ioctl_scrap_mem(18): exiting. ret=0.
qla2x00_get_ioctl_scrap_mem(18): inst=0 entered. size=160.
qla2x00_get_ioctl_scrap_mem(18): exiting. ret=0.
qla2x00_scsi_passthru(18): got FC SCSI passthru cmd.
qla2x00_sc_fc_scsi_passthru(18): inst=0 entered.
qla2x00_get_ioctl_scrap_mem(18): inst=0 entered. size=352.
qla2x00_get_ioctl_scrap_mem(18): exiting. ret=0.
qla2x00_sc_fc_scsi_passthru(18): inst=0 cmd for loopid=0081 L=0000
WWPN=50060e8000c28a03.
qla2x00_sc_fc_scsi_passthru Dump of cdb buffer:
 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
--------------------------------------------------------------
3c  02  00  00  00  00  00  00  08  00  00  00  00  00  00  00
qla2x00_sc_fc_scsi_passthru(18): inst=0 queuing command.
qla2x00_ioctl_scsi_queuecommand(18): entered.
qla2x00_ioctl_scsi_queuecommand(18): ha instance=0 tq=ec2d2800 lq=f10767c0
pfclun=f2cdc8c0 pfcport=f2b09780.
        CDB=3c 02 00 00; b=0 t=ff l=0.
qla2x00_ioctl_scsi_queuecommand(18): inst=0 sending command.
qla2x00_ioctl_scsi_queuecommand(18): exiting.
qla2x00_scsi_pt_done post function called OK
qla2x00_scsi_pt_done: exiting.
qla2x00_sc_fc_scsi_passthru(18): inst=0 data underrun or scsi err. host
status =0x0, scsi status = 0x302.
qla2x00_sc_fc_scsi_passthru(18): inst=0 done. host status=0x0, scsi
status=0x302.
qla2x00_sc_fc_scsi_passthru(18): inst=0 sense[0]=70 sense[2]=e.
qla2x00_sc_fc_scsi_passthru(18): inst=0 copying data.
qla2x00_sc_fc_scsi_passthru(18): inst=0 exiting.
qla2x00_free_ioctl_scrap_mem(18): inst=0 entered.
qla2x00_free_ioctl_scrap_mem(18): exiting.
qla2x00_scsi_passthru(18): exiting.

Sense Key 0xe means "data mismatch". But what does "scsi status=0x302" mean?
I didn't find any explaination on google. What causes the buffer test to
fail? Is the buffer a local buffer or a buffer on the storage box? Which
debug switches can I turn to inverstigate that signal loss issue?

I think I can exclude bad cables or defective ports on our switches and
HBAs, because we have four servers with two pathes each showing the same
errors. We are using qla2342-HBAs with SLES9. Our Storage Box is a HDS 9580V
and doesn't require special qla2xxx parameter settings according to Hitachi.
I've already tested the plain driver 8.00.02 from qlogic and a version
provided by HP (also 8.00.02). Currently I'm using 8.00.03b1. All versions
show the same error behaviour.

Kind regards,
Andreas Rother

-- 
Weitersagen: GMX DSL-Flatrates mit Tempo-Garantie!
Ab 4,99 Euro/Monat: http://www.gmx.net/de/go/dsl
