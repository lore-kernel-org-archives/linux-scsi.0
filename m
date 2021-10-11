Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBED9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FED660F35
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhJKNUc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:20:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhJKNUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 09:20:31 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BBVaAd017667;
        Mon, 11 Oct 2021 09:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=C0KmK8BgejZoW9MC9V+3etTfqZb5AZsvNCG84ugJTok=;
 b=TCe2Fd6cei7mrFBYRHG74urx4FGhEOeZ8aAlqD7c9BTFYLi6Z7TmeXNk2Jzp+cKLt1nt
 0BAbSdNdAHDF4vfM55pQ20DOTqlxbaBx1TY6M0uRwRKr6nQ9ITd6H72CDshaWKv+E+6F
 ydqYImdB/KhETfMeaL2vlGLNJOWjB0MXjh177hNDuIGCqkZWSa4ERM7FK8xQgU88lMH/
 xBBDxODJHXrzAlnNIZJ/uFUqolndFZ0aLdkK4XDxWYl2rQUtHTR6yQV8T8dK203onbPs
 xxJqlxE5DRO3y6dcff15NJMCC5lZyNlpHGr5tYrPuMgvROhrLQfyifrZCA0O+TxrYJxB xA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmmfmant7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:18:24 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BDDJNq012018;
        Mon, 11 Oct 2021 13:18:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3bk2q9cvx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 13:18:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BDClTR57606526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 13:12:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE49DA4062;
        Mon, 11 Oct 2021 13:18:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B247A4060;
        Mon, 11 Oct 2021 13:18:17 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.35.184])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Oct 2021 13:18:17 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mZvC5-005Dfn-0q; Mon, 11 Oct 2021 15:18:17 +0200
Date:   Mon, 11 Oct 2021 15:18:16 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 01/46] scsi: core: Register sysfs attributes earlier
Message-ID: <YWQ5mKafgOM2t1VN@t480-pf1aa2c2.linux.ibm.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-2-bvanassche@acm.org>
 <YWQ3mHOZ+881X+j1@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <YWQ3mHOZ+881X+j1@t480-pf1aa2c2.linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1XQJgMVG0H0BZjj4JsJo3mSMlNtvVeZe
X-Proofpoint-GUID: 1XQJgMVG0H0BZjj4JsJo3mSMlNtvVeZe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110076
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 11, 2021 at 03:09:44PM +0200, Benjamin Block wrote:
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 86793259e541..05b4d69d53d4 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1609,8 +1591,10 @@ static struct device_type scsi_dev_type = {
> >  
> >  void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> >  {
> > +	int i, j = 0;
> >  	unsigned long flags;
> >  	struct Scsi_Host *shost = sdev->host;
> > +	struct scsi_host_template *hostt = shost->hostt;
> >  	struct scsi_target  *starget = sdev->sdev_target;
> >  
> >  	device_initialize(&sdev->sdev_gendev);
> > @@ -1618,6 +1602,23 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> >  	sdev->sdev_gendev.type = &scsi_dev_type;
> >  	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
> >  		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
> > +	sdev->gendev_attr_groups[j++] = &scsi_sdev_attr_group;
> > +	if (hostt->sdev_attrs) {
> > +		sdev->lld_attr_group = (struct attribute_group){
> > +			.attrs = scsi_convert_dev_attrs(&sdev->sdev_gendev,
> > +							hostt->sdev_attrs)
> 
> Hmm, not sure, can this fail in practice? I mean the allocation in
> `scsi_convert_dev_attrs()`. Maybe we should warn at least once if this
> fails? It might render some userspace applications unusable (even some
> plumbing called with udev and such), with no clear signal from the
> kernel why the attributes are missing.
> 
> Previously we would return an error to the caller in
> `scsi_sysfs_add_sdev()` when some addition failed. But I'm not certain
> whether this new allocation falls under the "too small to fail" rule of
> thumb.

Ah.. nevermind you remove that part again in a later patch. Reading the
series I didn't realize. So probably just ignore the comment.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
