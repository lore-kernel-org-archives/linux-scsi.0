Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE5BC6FA99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 12:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCJMay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 07:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJMaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 07:30:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0093710A295
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 04:30:51 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AC4xVs020849;
        Fri, 10 Mar 2023 12:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7iDdBJSMhAIHWDWoDtSWM0HUJWlt5CGcZv6I/o76KYc=;
 b=co/4CdKPzFGN3I0YQGGueD7u2ptiYGQqkKsXAdTr/ROteZa/TGXQiLteOqpAlY5QsAm6
 WY84WM3g0G2Pt0QLWp/vPSkVcWd7vCRqCB1JaMxIFhax+TDJK1GhovGQ7AlCtnaTJUxo
 d8Fns58Bv5Keu9RDR7+mpdXwdvQfkKqPacCd9qHkLQAkHWXERSl4vluqXzoLeKyUJ7ZR
 eWI0jKEEA36eTIcnkNRn/af2jjbUlOkQ6NnPPI8yOFOrTzeLati44bNlD53WVBz5odty
 q/TCkd2o8JLy66RyfOPLdX690iGtmG/j+IWipjwpB3/MwbZcZn1bsntnmscMcsgVabV1 NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p7va7mqt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 12:30:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32ACKIh3003272;
        Fri, 10 Mar 2023 12:30:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p7va7mqsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 12:30:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A8fKkP014957;
        Fri, 10 Mar 2023 12:30:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3p6gbwau98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 12:30:38 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32ACUYje35979648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 12:30:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2C02004E;
        Fri, 10 Mar 2023 12:30:34 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7D1B2004B;
        Fri, 10 Mar 2023 12:30:34 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.179.10.180])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 10 Mar 2023 12:30:34 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pabtK-003tRc-0n;
        Fri, 10 Mar 2023 13:30:34 +0100
Date:   Fri, 10 Mar 2023 12:30:34 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Simplify the code for waking up the error
 handler
Message-ID: <20230310123034.GF620522@t480-pf1aa2c2.fritz.box>
References: <20230307215151.3705164-1-bvanassche@acm.org>
 <20230309121328.GD620522@t480-pf1aa2c2.fritz.box>
 <53e12a05-f485-f24c-0887-35900c2307c0@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <53e12a05-f485-f24c-0887-35900c2307c0@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o7AcBXSv68VLUvg2V082QOM73GtXW3hr
X-Proofpoint-GUID: erNop0sIb96v8XB_yPyn3rZ2jxiz2T-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_03,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100096
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 09:20:45AM -0800, Bart Van Assche wrote:
> On 3/9/23 04:13, Benjamin Block wrote:
> > On Tue, Mar 07, 2023 at 01:51:51PM -0800, Bart Van Assche wrote:
> >> scsi_dec_host_busy() is called from the hot path and hence must not
> >> obtain the host lock if no commands have failed. scsi_dec_host_busy()
> >> tests three different variables of which at least two are set if a
> >> command failed. Commit 3bd6f43f5cb3 ("scsi: core: Ensure that the
> >> SCSI error handler gets woken up") introduced a call_rcu() call to
> >> ensure that all tasks observe the host state change before the
> >> host_failed change. Simplify the approach for guaranteeing that the host
> >> state and host_failed/host_eh_scheduled changes are observed in order by using
> >> smp_store_release() to update host_failed or host_eh_scheduled after
> >> having update the host state and smp_load_acquire() before reading the
> >> host state.
> > 
> > It's probably just me, but "simplify" is a bit of a misnomer when you
> > replace RCU by plain memory barriers. And I'm kind of wondering what we
> > improve here? It seems to me that at least as far as the hot path is
> > concerned, nothing really changes? The situation for
> > `scsi_eh_scmd_add()` seems to improve, but that is already way off the
> > hot path.
> 
> Hi Benjamin,
> 
> The advantages of the approach introduced by this patch are as follows:
> * The size of struct scsi_cmnd is reduced. This may improve performance
>    by reducing the number of cache misses.
> * One call_rcu() call is eliminated. This reduces the error handler
>    wake-up latency.

Is that really a problem today? From personal experience we hardly ever
have any real SCSI timeouts in our environments, and once we are at the
point where we add commands to EH, we are already past the (default) 30s
timeout for disks IIRC, so is the RCU latency significant at that point?

I'm just wondering, because at least IMHO plain memory barrier are more
complex than RCU - at least in understanding them.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
