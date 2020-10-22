Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E929DC388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 16:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86D9C2464E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 16:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qX+QueXY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902085AbgJVQuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 12:50:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2902079AbgJVQuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 12:50:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MGXbET145857;
        Thu, 22 Oct 2020 12:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=l4guPT8owrjneCEhLz8biC2qYMo/u+zfvsp1gJ4HeR0=;
 b=qX+QueXY4TeyzkIaDDeoq6rDKg2ASypNgM8+V/vy8Wb6RUTeK5SxgXzjwiiHdUWg21eG
 93vXX4gyXoeJ3emsaooRf1EnpiflUgNjP2DC/67e4Ml6VfTvl6DmTK4FO0CNbVfGDoqq
 uV1BSRxWdMBThnDhhux7SaX3ZYIuOpMzszT4pHzqtYNSNdle9dYiEwBwp6y058IbdfbA
 ch+VULRYLF39ne658RRQG4v9Bh1V3eV+02VdNFLREcyEUH+YsvOCTOE5JMi75o6frTWD
 RHX3T++YCWqh5pX/rPj9J0JidbqD9JPrWa97SY6ZpuYhrcqq2tXyjwPfR3fnOUt4sZyy Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b00ka5f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 12:50:13 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MGfVrA170313;
        Thu, 22 Oct 2020 12:50:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34b00ka5dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 12:50:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MGl6l0005894;
        Thu, 22 Oct 2020 16:50:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 348d5qvv0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 16:50:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MGo7n730867746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 16:50:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94D4B11C054;
        Thu, 22 Oct 2020 16:50:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81F1111C05B;
        Thu, 22 Oct 2020 16:50:07 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.159.190])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 22 Oct 2020 16:50:07 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kVdmw-000ShK-J4; Thu, 22 Oct 2020 18:50:06 +0200
Date:   Thu, 22 Oct 2020 18:50:06 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH v3 16/17] scsi:zfcp: Added changes to
 fc_remote_port_chkready
Message-ID: <20201022165006.GA15064@t480-pf1aa2c2>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-17-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1602732462-10443-17-git-send-email-muneendra.kumar@broadcom.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_11:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Would be good if you could address the driver mails to the driver
maintainers :) I was out of office, but we might still miss it
occasionally.

On Thu, Oct 15, 2020 at 08:57:41AM +0530, Muneendra wrote:
> Added changes to pass a new argument to fc_remote_port_chkready
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
>=20
> ---
> v3:
> New Patch
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index d58bf79892f2..732e15e3a839 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -74,7 +74,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, str=
uct scsi_cmnd *scpnt)
>  	scpnt->result =3D 0;
>  	scpnt->host_scribble =3D NULL;
> =20
> -	scsi_result =3D fc_remote_port_chkready(rport);
> +	scsi_result =3D fc_remote_port_chkready(rport, scpnt);
>  	if (unlikely(scsi_result)) {
>  		scpnt->result =3D scsi_result;
>  		zfcp_dbf_scsi_fail_send(scpnt);
> --=20
> 2.26.2
>=20

This change looks fine to me for zfcp.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>


--=20
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Sys=
tems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/pri=
vacy
Vorsitz. AufsR.: Gregor Pillen         /        Gesch=E4ftsf=FChrung: Dirk =
Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: AmtsG Stuttgart, HRB =
243294
