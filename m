Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AA4C77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 10:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjECKZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 06:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjECKY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 06:24:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02244C21;
        Wed,  3 May 2023 03:24:54 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343ALsSr027349;
        Wed, 3 May 2023 10:24:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dye8a+H8bucNlWEZCzbiDWruWo73ghXExz9ggZmIr3w=;
 b=aHRxPc6+CojYTBf+haKVLOPQ3763HpOgST1mt1eo2ucblpMdR0ePZO+ju2iAq8tWECbW
 Pz2yUDk+cKjEZ9byjzlRCteSknVTM6jw7UO++Y9UJwMDb5gXLkdcNXdUbeD6OVC+rFjY
 kBBghUKDQ2DJnfgSVZ1lRI7eKKeeZMUgUZMUJpivwbhgPmGU5VWYiSsCHry/zs+Worof
 AVCdlxAJYIW14qS9Idp41sbEP9PoSaT+cOLJw7I7QgeoCdGni+LFzmIIqspFhXm4F2hS
 d9tUzHXZ2hPVeqinUGsoRdzzXG/246S9T5HEh1fhQ6O3cHzlyYv86x/YXaMpmP4dCoAz aQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbn75s764-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 10:24:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 343A8xqm024267;
        Wed, 3 May 2023 10:24:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6hs5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 10:24:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343AOfSs55640568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 10:24:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 779B0202C3;
        Wed,  3 May 2023 10:24:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52BFB202C0;
        Wed,  3 May 2023 10:24:41 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.89.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 10:24:41 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pu9f6-004KYC-27;
        Wed, 03 May 2023 12:24:40 +0200
Date:   Wed, 3 May 2023 10:24:40 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Hannes Reinecke <hare@suse.de>
Cc:     Maxime Bizon <mbizon@freebox.fr>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Aq1GZr53W8dLYoqg3nEeYjYxG42IRFNC
X-Proofpoint-GUID: Aq1GZr53W8dLYoqg3nEeYjYxG42IRFNC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_06,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=759 impostorscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030084
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 26, 2023 at 03:20:07PM -0400, Alan Stern wrote:
> > dmesg with timestamps so it's easy to spot the timeouts:
> 
> > [  211.733162] *** thread awakened
> > [  211.733174] Command READ_10 (10 bytes)
> > [  211.733183] bytes: 28 00 00 02 02 00 00 00 08 00
> > [  211.733192] Bulk Command S 0x43425355 T 0xb8cb L 4096 F 128 Trg 0 LUN 0 CL 10
> > [  211.733204] xfer 31 bytes
> > [  211.733288] Status code 0; transferred 31/31
> > [  211.733300] -- transfer complete
> > [  211.733306] Bulk command transfer result=0
> > [  211.733313] xfer 4096 bytes, 1 entries
> > [  218.089304] sd 0:0:0:0: [sda] tag#0 abort scheduled
> > [  218.109297] sd 0:0:0:0: [sda] tag#0 aborting command
> > [  218.109315] command_abort called
> > [  218.109324] -- cancelling sg request
> > [  218.112380] Status code -104; transferred 3072/4096
> > [  218.112393] -- transfer cancelled
> > [  218.112400] Bulk data transfer result 0x4
> > [  218.112407] -- command was aborted
> > [  218.209278] usb 1-1.2: reset high-speed USB device number 3 using orion-ehci
> > [  218.359923] usb_reset_device returns 0
> > [  218.359936] scsi command aborted
> > [  218.359947] *** thread sleeping
> > [  218.359964] sd 0:0:0:0: [sda] tag#0 retry aborted command
> > [  218.399298] *** thread awakened
> > [  218.399311] Command READ_10 (10 bytes)
> > [  218.399320] bytes: 28 00 00 02 02 00 00 00 08 00
> > [  218.399330] Bulk Command S 0x43425355 T 0xb8cc L 4096 F 128 Trg 0 LUN 0 CL 10
> > [  218.399342] xfer 31 bytes
> > [  218.399544] Status code 0; transferred 31/31
> > [  218.399556] -- transfer complete
> > [  218.399562] Bulk command transfer result=0
> > [  218.399570] xfer 4096 bytes, 1 entries
> > [  225.129297] sd 0:0:0:0: [sda] tag#0 previous abort failed
> > [  225.129337] scsi host0: Waking error handler thread
> > [  225.129358] scsi host0: scsi_eh_0: waking up 0/1/1
> > [  225.129375] scsi host0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> > [  225.129387] scsi host0: Total of 1 commands on 1 devices require eh work
> > [  225.129402] sd 0:0:0:0: scsi_eh_0: Sending BDR
> > [  225.129414] device_reset called
> > [  235.369290] INFO: task scsi_eh_0:173 blocked for more than 10 seconds.
> > [  235.369311]       Not tainted 6.3.0-00615-gffe64935a4a2 #9
> > [  235.369320] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  235.369327] task:scsi_eh_0       state:D stack:0     pid:173   ppid:2      flags:0x00000000
> > [  235.369350]  __schedule from schedule+0x70/0xac
> > [  235.369374]  schedule from schedule_preempt_disabled+0x24/0x34
> > [  235.369393]  schedule_preempt_disabled from __mutex_lock.constprop.0+0x14c/0x280
> > [  235.369412]  __mutex_lock.constprop.0 from device_reset+0x28/0x64
> > [  235.369433]  device_reset from scsi_try_bus_device_reset+0x24/0x58
> > [  235.369452]  scsi_try_bus_device_reset from scsi_eh_ready_devs+0x2f0/0x97c
> > [  235.369470]  scsi_eh_ready_devs from scsi_error_handler+0x238/0x49c
> > [  235.369488]  scsi_error_handler from kthread+0xc4/0xdc
> > [  235.369507]  kthread from ret_from_fork+0x14/0x3c
> > [  235.369567] INFO: task usb-storage:176 blocked for more than 10 seconds.
> > [  235.369576]       Not tainted 6.3.0-00615-gffe64935a4a2 #9
> > [  235.369583] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  235.369590] task:usb-storage     state:D stack:0     pid:176   ppid:2      flags:0x00000000
> > [  235.369606]  __schedule from schedule+0x70/0xac
> > [  235.369622]  schedule from schedule_timeout+0x18/0xd0
> > [  235.369641]  schedule_timeout from __wait_for_common+0xc0/0x13c
> > [  235.369660]  __wait_for_common from usb_sg_wait+0x10c/0x118
> > [  235.369677]  usb_sg_wait from usb_stor_bulk_transfer_sglist+0xc4/0x118
> > [  235.369695]  usb_stor_bulk_transfer_sglist from usb_stor_bulk_srb+0x24/0x3c
> > [  235.369713]  usb_stor_bulk_srb from usb_stor_Bulk_transport+0x164/0x44c
> > [  235.369731]  usb_stor_Bulk_transport from usb_stor_invoke_transport+0x20/0x5c4
> > [  235.369750]  usb_stor_invoke_transport from usb_stor_control_thread+0x1a4/0x2bc
> > [  235.369769]  usb_stor_control_thread from kthread+0xc4/0xdc
> > [  235.369786]  kthread from ret_from_fork+0x14/0x3c
> > 
> > 
> > Turns out eh_device_reset_handler() is called with a pending command
> > (srb == us->srb), and I don't know if the usb code was expecting
> > eh_abort_handler() to be called first.
> 
> usb-storage definitely expects any pending command to be aborted before 
> a reset is attempted.

From a cursory look at the logs above, SCSI ML does just try that:

> > [  218.089304] sd 0:0:0:0: [sda] tag#0 abort scheduled
> > [  218.109297] sd 0:0:0:0: [sda] tag#0 aborting command

calls `hostt->eh_abort_handler()` on the late request, and retries it
after success.

> > [  218.359964] sd 0:0:0:0: [sda] tag#0 retry aborted command
> > [  225.129297] sd 0:0:0:0: [sda] tag#0 previous abort failed

but it times out again, then we go straight into EH:

> > [  225.129337] scsi host0: Waking error handler thread
> > [  225.129358] scsi host0: scsi_eh_0: waking up 0/1/1
> > [  225.129375] scsi host0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> > [  225.129387] scsi host0: Total of 1 commands on 1 devices require eh work
> > [  225.129402] sd 0:0:0:0: scsi_eh_0: Sending BDR

IIRC in the past we used to call Abort a second time from within the EH
thread before trying the different resets, but that was removed at some
point a couple of years ago. Now we add the command straight to the EH
list, and start with the TMF LUN reset, which ought to implicitly abort
the command as well on the target.

> > This patch fixes the issue, not sure if it's correct:
> > 
> > --- a/drivers/usb/storage/scsiglue.c
> > +++ b/drivers/usb/storage/scsiglue.c
> > @@ -455,6 +455,9 @@ static int device_reset(struct scsi_cmnd *srb)
> >  
> >         usb_stor_dbg(us, "%s called\n", __func__);
> >  
> > +       if (us->srb == srb)
> > +               command_abort(srb);
> > +
> >         /* lock the device pointers and do the reset */
> >         mutex_lock(&(us->dev_mutex));
> >         result = us->transport_reset(us);
> 
> Maybe...  But it would be better to check first whether the SCSI core is 
> supposed to be reusing an active srb in this way.

IIRC it does indeed doe that by design. It saves the old command's
meta-data, and piggy-backs the TMF onto the existing request to push it
into the device driver.

Hannes probably knows the complete story.

> 
> Martin, can tell us what is supposed to happen here?  Is the 
> eh_device_reset_handler routine supposed to be called with a scsi_cmnd 
> for a currently active command?

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
