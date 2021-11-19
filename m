Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE175C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 18:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C962761B42
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 18:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhKSSW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 13:22:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41366 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhKSSW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 13:22:58 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJIHW2L014164;
        Fri, 19 Nov 2021 18:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=+IS7Heh4kpZN7WNKRQ/8WF0S9yXIhNl0l/8wD29QIas=;
 b=WX55utL8d3cDCYUCCWoEsRQTLKA0Ik7PS3FZPEbY2XsrPwpmV0uAOhSf+dFsQ/7aALea
 HF+eDcTM5zQ+MzzdUnM+TkiRAsBZ3TvYcC+ODCljTAS8FfqlMdEUdOIRmQMJoW0jqmfi
 +rby2xCaJEiB0MtKOocAOwx9nf5Kkh/YmCLZAcjkx0gz1THRAzgWzs6WxeAQD2v1xQgG
 9O3yZFDWyKg++jmKT76XyyZJLTaQtS0KSbJQRZQwxBOmPD3NjYajfTAn1ZoadEttlFwu
 vIWDWE0NYoUS4E0ry/Sez+v5Mu5hhuJUsHEuIq0aSoVw8W3X7grWbGG7J081yNnOS0TJ ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ceh2rg0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 18:19:42 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJIJNeV017579;
        Fri, 19 Nov 2021 18:19:42 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ceh2rg0y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 18:19:42 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJIH86r028933;
        Fri, 19 Nov 2021 18:19:41 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3ca50ehhh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 18:19:41 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJIJeOq21234014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 18:19:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BCA07805C;
        Fri, 19 Nov 2021 18:19:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BEE178067;
        Fri, 19 Nov 2021 18:19:39 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.93.152])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 18:19:38 +0000 (GMT)
Message-ID: <3bf7f06cd2b905dad77c9dda8cfa080c5114e731.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>
Date:   Fri, 19 Nov 2021 13:19:37 -0500
In-Reply-To: <85ff7a01-fd44-b036-b2c8-145f30790752@oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
         <20211105221048.6541-3-michael.christie@oracle.com>
         <b78c655594d3aa5c6ac5540dbf8fb931dce5a78b.camel@linux.ibm.com>
         <85ff7a01-fd44-b036-b2c8-145f30790752@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aJQ1SKJNn6e015FdElFMP8wAPwWpTEHs
X-Proofpoint-ORIG-GUID: oEhSq-uV_Nf1LjAt2EgYWTQ9xioK-PwS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_14,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-19 at 11:13 -0600, Mike Christie wrote:
> On 11/19/21 7:35 AM, James Bottomley wrote:
> > On Fri, 2021-11-05 at 17:10 -0500, Mike Christie wrote:
> > > This fixes a regression added with:
> > > 
> > > commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> > > offlinining device")
> > > 
> > > The problem is that after iSCSI recovery, iscsid will call into
> > > the kernel to set the dev's state to running, and with that patch
> > > we now call scsi_rescan_device with the state_mutex held. If the
> > > scsi error handler thread is just starting to test the device in
> > > scsi_send_eh_cmnd then it's going to try to grab the state_mutex.
> > > 
> > > We are then stuck, because when scsi_rescan_device tries to send
> > > its IO scsi_queue_rq calls -> scsi_host_queue_ready ->
> > > scsi_host_in_recovery which will return true (the host state is
> > > still in recovery) and IO will just be requeued.
> > > scsi_send_eh_cmnd will then never be able to grab the state_mutex
> > > to finish error handling.
> > > 
> > > To prevent the deadlock this moves the rescan related code to
> > > after we drop the state_mutex.
> > > 
> > > This also adds a check for if we are already in the running
> > > state. This prevents extra scans and helps the iscsid case where
> > > if the transport class has already onlined the device during it's
> > > recovery process then we don't need userspace to do it again plus
> > > possibly block that daemon.
> > > 
> > > Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> > > offlinining device")
> > > Cc: Bart Van Assche <bvanassche@acm.org>
> > > Cc: lijinlin <lijinlin3@huawei.com>
> > > Cc: Wu Bo <wubo40@huawei.com>
> > > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > > ---
> > >  drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
> > >  1 file changed, 19 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_sysfs.c
> > > b/drivers/scsi/scsi_sysfs.c
> > > index a35841b34bfd..53e23a7bc0d3 100644
> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct
> > > device_attribute *attr,
> > >  	int i, ret;
> > >  	struct scsi_device *sdev = to_scsi_device(dev);
> > >  	enum scsi_device_state state = 0;
> > > +	bool rescan_dev = false;
> > >  
> > >  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
> > >  		const int len = strlen(sdev_states[i].name);
> > > @@ -815,20 +816,27 @@ store_state_field(struct device *dev,
> > > struct
> > > device_attribute *attr,
> > >  	}
> > >  
> > >  	mutex_lock(&sdev->state_mutex);
> > > -	ret = scsi_device_set_state(sdev, state);
> > > -	/*
> > > -	 * If the device state changes to SDEV_RUNNING, we need to
> > > -	 * run the queue to avoid I/O hang, and rescan the device
> > > -	 * to revalidate it. Running the queue first is necessary
> > > -	 * because another thread may be waiting inside
> > > -	 * blk_mq_freeze_queue_wait() and because that call may be
> > > -	 * waiting for pending I/O to finish.
> > > -	 */
> > > -	if (ret == 0 && state == SDEV_RUNNING) {
> > > +	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING)
> > > {
> > > +		ret = count;
> > 
> > This looks wrong because of this
> > 
> > [...]
> > >  	return ret == 0 ? count : -EINVAL;
> > 
> > Don't we now return EINVAL on idempotent set state running because
> > the count is always non-zero?
> > 
> > I think the first statement should be 'ret = 0;' instead to cause
> > idempotent state setting to succeed as a nop.
> > 
> 
> You're right.
> 
> I'll resend this patchset with James's comment handled.

Send an incremental patch because this is already in the queue for
Linus and he'd go ballistic if we had to rebase to remove it.

James


