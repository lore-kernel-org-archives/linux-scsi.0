Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A642C4363C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 16:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083C4206CA
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 16:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aOR/pHna"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387777AbgJBQ0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:26:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733260AbgJBQ0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 12:26:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092GLdid014573;
        Fri, 2 Oct 2020 12:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=DljJcKHwTDZksBEo4XlmZDTY234NqUhjtE7Oqr++zWI=;
 b=aOR/pHna3HeUZ+CI4G7OCLYC7XdjopsQYH4D/lSLJJ8o673nfRT/YtsqtgpqHhNY09FC
 C4EafqNF25YQiCvNk7RQ5GmIuzVDKEKkbdOJcuuITgxRC3buv9QZIxC7doeHJjK2G2z8
 ebE4MnLCghGmafWCMxkPEbq0z14kyuIrg7QfVMJNVXhbzmtGNsZsVUF8h4quNkeG/00A
 T4NcEPb372RAESdXh0T0y3QUOSyuBtXbLmZIE2R8nB9zWs20TPlbUmijI3mbEgeAIn4e
 4GUiU4rbga8xJ4+xkUD1av6+qlb/71dzBB4SFoEBy5LPtkGGrCjqVdpeOem92HM5uGqw mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x7nm02es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 12:26:40 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092GPJG3021694;
        Fri, 2 Oct 2020 12:26:39 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x7nm02du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 12:26:39 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092GNDbA026184;
        Fri, 2 Oct 2020 16:26:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 33sw983hvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:26:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092GQYct31588702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 16:26:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E06CFA405B;
        Fri,  2 Oct 2020 16:26:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD39DA4054;
        Fri,  2 Oct 2020 16:26:34 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.161.178])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  2 Oct 2020 16:26:34 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kONtB-0008rQ-TZ; Fri, 02 Oct 2020 18:26:33 +0200
Date:   Fri, 2 Oct 2020 18:26:33 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute
 port_state
Message-ID: <20201002162633.GA8365@t480-pf1aa2c2>
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 28, 2020 at 10:20:56AM +0530, Muneendra wrote:
> Added a new sysfs attribute port_state under fc_transport/target*/
> 
> With this new interface the user can move the port_state from
> Marginal -> Online and Online->Marginal.
> 
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> Below is the interface provided to set the port state to Marginal
> and Online.
> 
> echo "Marginal" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> echo "Online" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> 
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.

Hey Muneendra, out of curiosity, what drives these changes to the
port_state in userspace, and based on what?

I imagine something uses the other bunch of sysfs attributes that were
introduced recently that get feed by FPIN notifications about congestion
and such, or? 

If so, is there any plans to integrated something along the lines in
multipathd/multipath-tools? Or maybe I missed that.

                                                            - Benjamin

> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/ to
> port_state for changing the port_state to a marginal state
> ---
>  drivers/scsi/scsi_transport_fc.c | 140 +++++++++++++++++++++++++++----
>  1 file changed, 122 insertions(+), 18 deletions(-)
> 


-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
