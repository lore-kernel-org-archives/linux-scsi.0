Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EDA3BB664
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284128; cv=none; b=eyAUt4KXl5rfSaP/duC8b/z8kpJQVYgn1KGbX5da0IqWZQhef0x412IYhjGan6sG0oU66RxDvT8B4o4X0qCn3N1Fx09t3tCxtmoaMnhY+h/WDIYrAIvJ5akIQOC7SVXN17eFfw8QsQNV5tUytvPiZHwmNrwAZHdeuNfeXrWn8zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284128; c=relaxed/simple;
	bh=9bNI51YMtAF7tCIzavxuP+Bw10YD+bsCUTTTQ43Ue9w=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfLWnuaA/syasFlH9G5rfTP+dWpHwfvbJvlHBAeDKSGDvPaqkyJ7IE4XCEq1posMGIovTsdHR/kaC1EYfOlEshchHmHZtYN4Tto4d/PHp+P1p+Q6h1rXhJISndVxp7Y+ypiEm95F/q3nTdKpoCRmjo3cNcQJ53yUXDeS/6ryAY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lWMM+cx8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WIzBGu/4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lWMM+cx8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WIzBGu/4"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HASiI91515698
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 10:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GJCYGiRTawctkNCl84JlSf9o1HOO8bimM+ytWBDPjmM=; b=lWMM+cx8feBhLbB2
	RcU69sEZ19EFRyEhb9A1VlQL2OUkZVo0zr4NEVHWXcWmLjf27vyWPqvPIact2Msw
	UDwA1jROHqthGHeU5NDvInGMXMVrIhNhQU16pVHxzDhT2t9TEyou1FZfnxC58mjA
	vbXQasGZKE8BdB73UcxL1DYH2WDua+oxEAbonDLS2LvmLtoJBVUTpeKFe5UU/zpQ
	C8lhuWYMg+Mmp53VPnVDFBAfghi/ZuGv3OPNVGNv4sMrNaQTMo2LPIxroj+oJjkM
	GfJYhP6YC2EpoEpz0g3y+CTA1nlwwKQP8kNEsy+3sMfFVSYjurYDHtXFEP1iE8/y
	fsfRMA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff9grvkf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 10:28:44 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51a8c689b5fso139277441cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784284118; x=1784888918; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJCYGiRTawctkNCl84JlSf9o1HOO8bimM+ytWBDPjmM=;
        b=WIzBGu/4On+lVkpidoyrEhYSla3kkmY9wUAZHlyTkZZqOCAUjSVoIBptD1/EqN5q15
         MK0dTCN/G5ovkvXj9+MGM2F88CGFC+egdWgpHgclNiEWIOwF+ryfoTQwaQNJY6caYE4/
         1ifpI/sFBIg0L7WzzXEJJ3e5se+adXUP5a6XoyRwLBwieEDjiCSAArQT1dPpeP5bGqXz
         2f7BymM/dV+8ORL7DXMWvC50d2T1fpsy1SE2YSGqXhH62qMQVih4N+Z4cnZl9WkVCkVx
         34VgQ0E1OLP2vabTJN+gamq2VDutVDz80X+dq0EyBxuXNrj+sCp/SZXXlrVN7ApSRssR
         qjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784284118; x=1784888918;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GJCYGiRTawctkNCl84JlSf9o1HOO8bimM+ytWBDPjmM=;
        b=sNYIp1L8DVg2MWpZ4EaVS8XBPF11cWr2jRfsid5kq9JdtAHK5GRX6Y9eY76WMGm4En
         stewY93WxAN2mhAwBnedC6MsTKQ+jS8NP1voi80OfRt5i1c775x0cxIhbnh+fqyEmdt/
         m6oqUBlRQt8yxC3FtHTSpsyvDDZ21VMrpqGjtN/mFVZCmoe0Y1dysl18ThVOkE1bX2Ex
         fLjNDzlTkIeIvImXlFZVcyEGzakBXZzCgxQVQPwjk29V2ziHiyToHOj2UOD1+8KPZ0s8
         9kR356L4cjgSITmVutvEqRhGZjs1NT1uo8M/AismAvD3a9aAG2TFxJZ7HY+QkhMNe+Hm
         3Z0w==
X-Forwarded-Encrypted: i=1; AHgh+Rr8cZB+ES9WKyOiYNO2DwYWviVhcF2OPVnExlrDq82mUF/JLOaPmde3jD0LtrVuvCPieH0zQBeqpdv6@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr+gCLMLAx+PENlQBi2XkZST/VxjPilGHJoIXq62CC0S9/ZnLm
	E82KNYRhOwfefaIQK+tMN5PcgM6egMzcC8Eug7RsFkInP3Dy1b7qOims8xbcXJ+GAspdUOvs8/s
	xgMJhdoG2sLQ408xrtudx7ntb8kIyTjyTnqfOP4IU5khuCJJB8EOVa71ldqhb9BMA
X-Gm-Gg: AfdE7cnR3k3b65Mf/LKxZ6TDUJqJlL6TtRF/PmzRNDztVu9X842FJfdnzWxIBvLuXM2
	rQZaxaMlAI3i8Cit++wMCDuAW3ox2J2WgXaZpTKzcZCx34MaTxsJuL5CQMqHaN+6H/4vkNUjRH7
	7+cHrpqQD9JBkmAPR2qjbl202NMd2tXoAhFVV3u9althIwDPE8VUuUnEL8i0WGJrzs7TazAALPg
	yg6LanS+BnUOCBcmk4OKccQvvfjBJYxqdYZU3am84YFdKjIklN91gvY1YseBpBrfIVCfcp+yBGI
	jvhj6qK2G03GPPyxs6ffMzmtJeUEn5DKJot5qVLs5VMLTu17kvFsX/TLmlJsQsU9NP1nMfIvln8
	Y2ka3N5QXAZJVwJoQFfP9XlYnuVwmRasOKT4=
X-Received: by 2002:a05:622a:228a:b0:51c:667:7e30 with SMTP id d75a77b69052e-5213e28e24emr15579851cf.47.1784284118494;
        Fri, 17 Jul 2026 03:28:38 -0700 (PDT)
X-Received: by 2002:a05:622a:228a:b0:51c:667:7e30 with SMTP id d75a77b69052e-5213e28e24emr15579581cf.47.1784284117985;
        Fri, 17 Jul 2026 03:28:37 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm76488975e9.14.2026.07.17.03.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 03:28:37 -0700 (PDT)
From: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
X-Google-Original-From: Jorge Ramirez <JorgeRamirez-Ortiz>
Date: Fri, 17 Jul 2026 12:28:35 +0200
To: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Cc: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: Re: [PATCH v1 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Message-ID: <aloD00lgh6gCzsCG@trex>
References: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
 <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
 <CAGgiveXtErFjDgxN9reR7s705U3wnnH65c4Su06ZQz_7EYwzuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGgiveXtErFjDgxN9reR7s705U3wnnH65c4Su06ZQz_7EYwzuA@mail.gmail.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEwNSBTYWx0ZWRfX4WrTLNDvBGkg
 t9mx1ImLtVbmGRBAeSdUDPuafFDsNigbF11fvnlYGydVJgW9jSjPlV05/T7/pewyxqriTC+sLjC
 KbwcTZmFAmKI2cvgyHCL7AprinLq8N4=
X-Proofpoint-ORIG-GUID: WLCVHDn4q_Sgz4Cl53eTqMgGnjjvC8gO
X-Proofpoint-GUID: WLCVHDn4q_Sgz4Cl53eTqMgGnjjvC8gO
X-Authority-Analysis: v=2.4 cv=TaumcxQh c=1 sm=1 tr=0 ts=6a5a03dc cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=NEAV23lmAAAA:8 a=voM4FWlXAAAA:8 a=EUspDBNiAAAA:8 a=AhAad4elxc9sd5kYIg8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEwNSBTYWx0ZWRfXy4FE4hOayPU8
 +ZwjN68yVnPA5ICcLFcDf4j3P6fSK9Eiq6iP19CurvnUzRgqa0o1vQvn+b30nRWbkHBQ8N1dg11
 rIqYktc3Y3pJrHOe+bf6qEbVNtiWbWmPEq7znN5lrVhro2qISzNcXv2YRjF4ybwvHQ+Xl8IXVwH
 2WhzCbQ6Rh8vxKrxg9joojPDwCRFhmLlmkYp97Vy4sttT6RF/ZHtP0zqrGeRSy1TqZhWDXgS3ZA
 ZQoehje1xZIxvJAl25uK+dC3d7qaLiq92RXZOFueJcjvH4n4mpTWy5I1cmCyIEyNSTE5weOGg+/
 Yb4j8HC1DyEI0qBwth1oAv4cOlncKK7y0Nhmcei3CERsDbEwWA69Oln32eIadg0H7MxBPn/bczu
 hDFdKBdeMP3p/YZNCgd7jQGne/Oy1Gxi0Jzi2Xmc0WXbdL8DzNtUl2CwJ6wMQBWv6Pi9WFG/XtU
 NVfsiiUWzkWxK4S7uiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0
 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170105

On 17/07/26 11:38:31, Jens Wiklander wrote:
> Hi Jorge,
> 
> On Thu, Jul 16, 2026 at 10:37 AM Jorge Ramirez-Ortiz
> <jorge.ramirez@oss.qualcomm.com> wrote:
> >
> > The RPMB authentication key is derived from the dev_id handed to the
> > RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> > is the eMMC CID, a fixed 16-byte value, and it derives the key on that
> > assumption.
> >
> > The UFS RPMB id built here is "<device_id>-R<region>", which is variable
> > length and longer than 16 bytes. Passing it verbatim would tie the
> > derived key to a length OP-TEE does not expect and diverge from the
> > fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
> > UFS ids.
> 
> Yes, if it's possible, It's nice to avoid that.
> 
> >
> > Hash the UFS id into a fixed 16-byte dev_id with blake2s instead. This
> > keeps the derived key stable and unique per region while matching the
> > eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
> > identical and no OP-TEE change is needed.
> >
> > Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
> > ---
> >  drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> > index d0c7ea7a36f4..b800871269bb 100644
> > --- a/drivers/ufs/core/ufs-rpmb.c
> > +++ b/drivers/ufs/core/ufs-rpmb.c
> > @@ -10,6 +10,7 @@
> >   *     Can Guo <can.guo@oss.qualcomm.com>
> >   */
> >
> > +#include <crypto/blake2s.h>
> >  #include <linux/module.h>
> >  #include <linux/device.h>
> >  #include <linux/kernel.h>
> > @@ -21,6 +22,7 @@
> >  #include <linux/unaligned.h>
> >  #include "ufshcd-priv.h"
> >
> > +#define UFS_RPMB_ID_LEN                        16      /* Match eMMC CID Length */
> >  #define UFS_RPMB_SEC_PROTOCOL          0xEC    /* JEDEC UFS application */
> >  #define UFS_RPMB_SEC_PROTOCOL_ID       0x01    /* JEDEC UFS RPMB protocol ID, CDB byte3 */
> >
> > @@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> >  {
> >         struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> >         struct rpmb_dev *rdev;
> > +       char *dev_id = NULL;
> >         char *cid = NULL;
> >         int region;
> >         u32 cap;
> > @@ -213,8 +216,17 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> >                         goto err_out;
> >                 }
> >
> > -               descr.dev_id = cid;
> > -               descr.dev_id_len = strlen(cid);
> > +               dev_id = kzalloc(UFS_RPMB_ID_LEN, GFP_KERNEL);
> > +               if (!dev_id) {
> > +                       device_unregister(&ufs_rpmb->dev);
> > +                       ret = -ENOMEM;
> > +                       goto err_out;
> > +               }
> > +
> > +               blake2s(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
> > +
> > +               descr.dev_id = dev_id;
> > +               descr.dev_id_len = UFS_RPMB_ID_LEN;
> 
> This change will break current users of this interface, if there are
> any. There are currently no upstream users in OP-TEE since you're
> adding that with https://github.com/OP-TEE/optee_os/pull/7881, but I
> suppose that's not the only use case.


I was wondering too - but since this is an OP-TEE driver (at least that
is what the module directive says at the bottom of the file) - I chose
to do it here (cleaner).

But we could take care of this on the rpc.c instead

A similar sort of change will need to go to U-boot but since the current
CID is broken anyway, I believe we will be able to go that route as
well.

See: https://patchwork.ozlabs.org/project/uboot/patch/20260717093013.3253643-1-jorge.ramirez@oss.qualcomm.com/

BTW I need to send another revision of this set (we need to use blake2b
(there is no support for blake2s in U-boot). But I'll wait for comments
if this is the right way to go instead of using full-size srings (ie, 88
characters on this particular case which seems desproportionate IMO)

> 
> Cheers,
> Jens
> 
> 
> >                 descr.capacity = cap;
> >
> >                 /* Register RPMB device */
> > @@ -228,6 +240,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> >
> >                 kfree(cid);
> >                 cid = NULL;
> > +               kfree(dev_id);
> > +               dev_id = NULL;
> >
> >                 ufs_rpmb->rdev = rdev;
> >                 ufs_rpmb->region_id = region;
> > @@ -240,6 +254,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> >         return 0;
> >  err_out:
> >         kfree(cid);
> > +       kfree(dev_id);
> >         list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
> >                 list_del(&it->node);
> >                 device_unregister(&it->dev);
> > --
> > 2.54.0
> >
