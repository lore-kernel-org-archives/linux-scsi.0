Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56549C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2918360E8B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 13:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhJKN2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:28:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235197AbhJKN2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 09:28:38 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BBTP64021323;
        Mon, 11 Oct 2021 09:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XFBgWPGD5Btfr/HjRjDhPSP+dIJrknGJ+8Whv1yHzPc=;
 b=gMOP3mCEyvUcSyKzoejqkgy6wr4yE65SP7gb836lj03NLCDeu7vTCBj4rRlMJQEhfqIH
 gskj7xXdYyxsezRLFQfC9l9BTyQy71eAvoWKbbqgGJcYkkjoCPuShntylLw1kA6dwLdh
 u+DMKu5ejzXpDg2VNDnKAoeF8DGkmqK0R4Mpa6iFSy0g+swuWbY7lx2uC6ih0BPNv7p7
 wGHvZZmkm8pgcnpB+ALhKSUvqIjN4jUbGcV9TeOGSmBFoUcAUB0cShDR18PYsdIitHj7
 d058VuLKLqq3TTJTS+v0Gw7QSQk5vWZ7uf/NPVdViF+OC6vEU220srUGVKChjVPUBt/c Iw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmj9s5n4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:26:34 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BDCcH8018112;
        Mon, 11 Oct 2021 13:26:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2q9cxws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 13:26:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BDQSAj50659822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 13:26:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15A8952050;
        Mon, 11 Oct 2021 13:26:28 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.35.184])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 0331A5204E;
        Mon, 11 Oct 2021 13:26:28 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mZvJz-005Do0-D0; Mon, 11 Oct 2021 15:26:27 +0200
Date:   Mon, 11 Oct 2021 15:26:27 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 06/46] scsi: zfcp: Switch to attribute groups
Message-ID: <YWQ7g3tpmPBVO0dc@t480-pf1aa2c2.linux.ibm.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-7-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20211008202353.1448570-7-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IFyZsehr1LJlJF3VwOLJ0V762seVq8PA
X-Proofpoint-ORIG-GUID: IFyZsehr1LJlJF3VwOLJ0V762seVq8PA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110076
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Bart,

just a small nitpick here.

On Fri, Oct 08, 2021 at 01:23:13PM -0700, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/s390/scsi/zfcp_ext.h   |  4 +--
>  drivers/s390/scsi/zfcp_scsi.c  |  4 +--
>  drivers/s390/scsi/zfcp_sysfs.c | 52 +++++++++++++++++++++++-----------
>  3 files changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
> index 6bc96d70254d..7b7b567186d6 100644
> --- a/drivers/s390/scsi/zfcp_ext.h
> +++ b/drivers/s390/scsi/zfcp_ext.h
> @@ -184,8 +184,8 @@ extern const struct attribute_group *zfcp_sysfs_adapter_attr_groups[];
>  extern const struct attribute_group *zfcp_unit_attr_groups[];
>  extern const struct attribute_group *zfcp_port_attr_groups[];
>  extern struct mutex zfcp_sysfs_port_units_mutex;
> -extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
> -extern struct device_attribute *zfcp_sysfs_shost_attrs[];
> +extern const struct attribute_group *zfcp_sdev_attr_groups[];
> +extern const struct attribute_group *zfcp_shost_attr_groups[];

I'd prefer it, if you leave the `zfcp_sysfs_` intact; while not
universally used in the whole driver, its a convention we've been trying
to follow regarding the symbols declared by the driver in the recent
time (`zfcp_sysfs.o` is the compilation unit).

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
