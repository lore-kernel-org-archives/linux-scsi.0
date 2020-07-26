Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7E3C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 18:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92BC720714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 18:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wDW/3vjE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGZSi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 14:38:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgGZSi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 14:38:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06QIbx0C082867;
        Sun, 26 Jul 2020 18:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VyREZUMBrtWdFUD+uUI7DsAjSnDNv5MTuIfaBrWgI4o=;
 b=wDW/3vjEnyP64aF/LNjMsm8v55xnUqcOwKfXmkCAeu20hknu02F/pf9wArYRGVNmtAZ1
 2fl1XHzGH/1znmBGmRMbdE+nal0qdWW3KLJB4x7tCuES254MGhtXWGpIpG04kbFMUulj
 mmxKEkbpCSF0OxTOSFQQZls+REeX3ptEgcnvmiEnOzEbiYlspCJDv3PSmgVdcpKnbZIw
 V5vtIRjonDlh4ugmltQG+tOyPOi2RVXPtCtAAyTLrAWt9jFZ8QtBf3ogUiN64akJtYZ/
 G4bJE44v1IxDPByhEv3YbjsfBK+JA8R8cvrw959ld3ffW0aAUvmypFGNbsKUhFecS3Nt gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32gxd3hn6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 26 Jul 2020 18:38:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06QIJF1Y093057;
        Sun, 26 Jul 2020 18:38:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32hdppbhem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jul 2020 18:38:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06QIcMMS017549;
        Sun, 26 Jul 2020 18:38:22 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jul 2020 11:38:22 -0700
Subject: Re: [PATCH v3 0/8] scsi: target: tcmu: Add TMR notification for tcmu
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <283dd5a6-b925-a33a-f481-f4b7bff2517b@oracle.com>
Date:   Sun, 26 Jul 2020 13:38:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9694 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007260146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/20 10:35 AM, Bodo Stroesser wrote:
> This patch series is made on top of Martin's for-next branch.
> 
> ChangeLog:
> 
> v2: in patch "scsi: target: tcmu: Implement tmr_notify callback"
>     changed new comment's style from "// ..." to "/* ... */"
>     and correctly use "/** " for function doc.
> 
> V3:
>  - Patch 1 "scsi: target: Modify core_tmr_abort_task()":
>    fixed wrong spin_lock handling. Nested calls to
>    spin_lock_irqsave and spin_lock_irqrestore used the same
>    flags field. Inner pair replaced by spin_lock / spin_unlock
>     
>  - Patches 5,7,8:
>    "scsi: target: tcmu: Factor out new helper ring_insert_padding"
>    "scsi: target: tcmu: Implement tmr_notify callback"
>    "scsi: target: tcmu: Make TMR notification optional"
>    New definitions of struct tcmu_dev *dev renamed to *udev.
> 
>  - Patch 8 "scsi: target: tcmu: Make TMR notification optional"
>    Spacing fixed at function definition.
> 
> ---
> 
> TCM/LIO core handles TMRs without involving backends.
> But TMR completion message is sent to initiator only after
> commands aborted by the TMR are completed by the backend.
> Especially in case of tcmu backend, if userspace executes long
> running commands and therefore initiator sends ABORT_TASK on
> timeout, the ABORT itself can time out if core still waits for
> userspace/tcmu to complete the command.
> 
> It would be very helpful for userspace to get a notification
> about received TMR and which commands were aborted by that TMR.
> Then userspace can decide whether to cancel command processing,
> and it can send command completion earlier than it would without
> TMR notification.
> It is also helpful for userspace traces and device emulation to
> get notification about TMR events.
> 
> So this patch series in the first two patches implements in
> core the usage of a new optional backend callback for TMR
> notifications. The core calls it before core waits for
> completion of aborted commands (params: se_dev, TMR type,
> and list of se_cmds aborted by this TMR).
> Of course other backends than tcmu can use this part of the
> series also to implement their own TMR notification if
> necessary.
> 
> The further six patches implement the TMR notify callback for
> tcmu. The new configFS attribute tmr_notification allows to
> switch on TMR messages on the cmd ring. The default of the
> attribute is the old behavior without TMR info on the ring, but
> with following changes:
>  - if tcmu receives an already aborted command, it immediately
>    rejects it. So it will never appear in userspace.
>  - if tcmu finds, that according to TMR notification a cmd on
>    the qfull_queue was aborted, tcmu removes it from qfull_queue
>    and completes it immediately. So userspace will not 'see'
>    those commands.
> 
> When attribute tmr_notification is set to 1, tcmu additionally
> prepares a list of cmd_ids from those commands, that are aborted
> by the TMR and are active in cmd ring (not timed out).
> This list together with the TMR type is either immediately
> written to cmd ring (new TMR entry type) or queued in a separate
> tmr queue if ring space is too small.
> TMRs in the tmr queue do not time out. If ring space becomes
> available, tcmu moves TMRs from tmr queue to ring with higher
> priority than cmds from qfull queue.
> 
> This mechanism makes sure that userspace receives TMR
> notifications as early as possible. Userspace can use the
> list of cmd_ids attached to the TMR notification to identify
> aborted commands from its list of received and not yet completed
> commands. In case userspace has meanwhile completed some of the
> cmd_ids on the list, it can just ignore these cmd_ids.
> A possible new command having the same cmd_id as one of the
> aborted commands will always appear on the ring after the TMR
> notification.
> 

Thanks for all the work on this.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

