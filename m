Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A46CC77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 12:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjECMwB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 08:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjECMwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 08:52:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C17B1FD2;
        Wed,  3 May 2023 05:51:58 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343Cnwx0031021;
        Wed, 3 May 2023 12:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0061/xbyDqysihiujashCxzv/PhNTXjn9gU/e9FKXtM=;
 b=WtppysMd/GgJ5+SzcfpvvE8TUqHlJBr7kMAHVXsVmlacoRMhPM8wZu6JMTI8sgKzzhLG
 fz7xzJcqW6lNHQ7bUIVueTTKGy3yDq3IGwhjjSsc5Y/iXWizUb8wIbyvHVjdkG4DSHjS
 lF6OGLrSfrG0SJ2Hn+eA+5dOwsx4MmggqbTM/SctOh/PXRhJRN8TtJ0mqypephJRZOLS
 mkJ+FXpLFUF/uPcEHObm2+cnornSMEPR5j/D7wvomohT02cihEgzG8944ngVkfhTHNrl
 lxFirhJyypACs+dlAswm00PxuHZIBc3aMN2Wht89/JYQgIT7VhdZXCVssw4wwUHWT8PY Zw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbqk1rw4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 12:51:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 343CdFsR016650;
        Wed, 3 May 2023 12:51:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q8tgg280v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 12:51:40 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343Cpcev5374602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 12:51:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 306EC2004B;
        Wed,  3 May 2023 12:51:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B85C20043;
        Wed,  3 May 2023 12:51:38 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.95])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 12:51:38 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1puBxJ-004WHr-1w;
        Wed, 03 May 2023 14:51:37 +0200
Date:   Wed, 3 May 2023 12:51:37 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Hannes Reinecke <hare@suse.de>,
        Maxime Bizon <mbizon@freebox.fr>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <20230503125137.GA1032383@t480-pf1aa2c2.fritz.box>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
 <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
 <941e8420-f99f-5832-2ea9-3ba5eca545ad@suse.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <941e8420-f99f-5832-2ea9-3ba5eca545ad@suse.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IAgUAYXcCbFDCh3QIO51ooWL268T4Lp2
X-Proofpoint-GUID: IAgUAYXcCbFDCh3QIO51ooWL268T4Lp2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_08,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 mlxlogscore=615 mlxscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 12:55:03PM +0200, Oliver Neukum wrote:
> On 03.05.23 12:24, Benjamin Block wrote:
> > On Wed, Apr 26, 2023 at 03:20:07PM -0400, Alan Stern wrote:
> 
> >  From a cursory look at the logs above, SCSI ML does just try that:
> > 
> >>> [  218.089304] sd 0:0:0:0: [sda] tag#0 abort scheduled
> >>> [  218.109297] sd 0:0:0:0: [sda] tag#0 aborting command
> > 
> > calls `hostt->eh_abort_handler()` on the late request, and retries it
> > after success.
> > 
> >>> [  218.359964] sd 0:0:0:0: [sda] tag#0 retry aborted command
> >>> [  225.129297] sd 0:0:0:0: [sda] tag#0 previous abort failed
> > 
> > but it times out again, then we go straight into EH:
> 
> And that is problematic to usb-storage
> > 
> >>> [  225.129337] scsi host0: Waking error handler thread
> >>> [  225.129358] scsi host0: scsi_eh_0: waking up 0/1/1
> >>> [  225.129375] scsi host0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> >>> [  225.129387] scsi host0: Total of 1 commands on 1 devices require eh work
> >>> [  225.129402] sd 0:0:0:0: scsi_eh_0: Sending BDR
> > 
> > IIRC in the past we used to call Abort a second time from within the EH
> > thread before trying the different resets, but that was removed at some
> > point a couple of years ago. 

Seems like I misremembered. Can't find the commit I was thinking
happened, and the only thing that changed was that aborts moved out of
the EH thread and be asynchronous.

> > Now we add the command straight to the EH
> > list, and start with the TMF LUN reset, which ought to implicitly abort
> > the command as well on the target.
> 
> usb-storage can do a reset only on the USB device level,
> which translates to a bus reset on the SCSI level.
> 
> And we are supposed to cancel any communication with the device
> before that.

Is that a limitation of the devices or drivers? Because then you don't
match SCSI semantics for LU reset - which aborts all running commands
on that scope among things. Which might explain the reason/choice behind
this unexpected behavior for you.

On random thought I had: in theory you could implement your own EH
strategy handler if the default one doesn't work for you. ATA and SAS do so.
[drivers/scsi/scsi_error.c:2285 `shost->transportt->eh_strategy_handler()`]
This can re-use parts/all of the existing escalation sequence in
`scsi_eh_ready_devs()`.

But that's no short-term fix.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
