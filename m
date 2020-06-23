Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CAEC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 10:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13AF20724
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 10:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbgFWKoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 06:44:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732135AbgFWKoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 06:44:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NAXAXJ098070;
        Tue, 23 Jun 2020 06:44:38 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ufmyruwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:44:38 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05NAfv4U011201;
        Tue, 23 Jun 2020 10:44:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 31sa381yp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:44:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05NAiX6H60293182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 10:44:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40494AE05F;
        Tue, 23 Jun 2020 10:44:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C7F7AE055;
        Tue, 23 Jun 2020 10:44:33 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.42.240])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Jun 2020 10:44:33 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jngPn-002vYU-Vw; Tue, 23 Jun 2020 12:44:32 +0200
Date:   Tue, 23 Jun 2020 12:44:31 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Bob Liu <bob.liu@oracle.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        lduncan@suse.com, maier@linux.ibm.com
Subject: Re: [PATCH 2/2] scsi: register sysfs for scsi/iscsi workqueues
Message-ID: <20200623104431.GE9340@t480-pf1aa2c2>
References: <20200611100717.27506-1-bob.liu@oracle.com>
 <20200611100717.27506-2-bob.liu@oracle.com>
 <cf9ae940-87b2-c8a1-3dba-4d2b57ebe9dd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf9ae940-87b2-c8a1-3dba-4d2b57ebe9dd@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_05:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1011
 cotscore=-2147483648 mlxlogscore=999 adultscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230079
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 22, 2020 at 10:40:09AM -0500, Mike Christie wrote:
> On 6/11/20 5:07 AM, Bob Liu wrote:
> > This patch enable setting cpu affinity through "cpumask" for below
> > scsi/iscsi workqueues, so as to get better isolation.
> > - scsi_wq_*
> > - scsi_tmf_*
> > - iscsi_q_xx
> > - iscsi_eh
> > 
> > Signed-off-by: Bob Liu <bob.liu@oracle.com>
> > ---
> >   drivers/scsi/hosts.c                | 4 ++--
> >   drivers/scsi/libiscsi.c             | 2 +-
> >   drivers/scsi/scsi_transport_iscsi.c | 2 +-
> >   3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 1d669e4..4b9f80d 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -272,7 +272,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >   	if (shost->transportt->create_work_queue) {
> >   		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
> >   			 "scsi_wq_%d", shost->host_no);
> > -		shost->work_q = create_singlethread_workqueue(
> > +		shost->work_q = create_singlethread_workqueue_noorder(
> >   					shost->work_q_name);
> >   		if (!shost->work_q) {
> >   			error = -EINVAL;
> 
> This patch seems ok for the iscsi, fc, tmf, and non transport class scan
> uses. We are either heavy handed with flushes or did not need ordering.
> 
> I don't know about the zfcp use though, so I cc'd  the developers listed as
> maintainers. It looks like for zfcp we can do:

Thx for the notice.

> 
> zfcp_scsi_rport_register->fc_remote_port_add->fc_remote_port_create->scsi_queue_work
> to scan the scsi target on the rport.
> 
> and then zfcp_scsi_rport_register can call zfcp_unit_queue_scsi_scan->
> scsi_queue_work which will scan for a specific lun.
> 
> It looks ok if those are not ordered, but I would get their review to make
> sure.

I am not aware of any temporal requirements of those LUN-scans, so I
think making them not explicitly ordered shouldn't hurt us.

The target scan itself is protected again by `shost->scan_mutex`.. so
all fine I think.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
