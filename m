Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8723A16AA
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784281126; cv=pass; b=YA0mt+cyieJfhqBDyWYk0l17ZeNx2NlP0a6Jv0sgFPwpFq3OnbA425dRz2vVQKj5OsGyqUwS3yFx5WycSjvgzzo22OSvaibXA/ybMZ+8HFrus3rtS4dF1a+gxoWEa7h6UYWB52TgUBWRMSrNhCM1fp9wjT2LYN0tMUawOPJ8z7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784281126; c=relaxed/simple;
	bh=gKgeA9w2lvXNBlVpC/vszCTY3PxeBizUQZBLIlohBF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AExEbw1OK0ygH+aFSFJthqf5nfe9YfuTF14UsCbbsCINRkFpDJjivcEpE8nYE9MdqzOSD2X4qWoLFqTCU5nv0XYQ8rfROr8zV/eb+esHmoxsjJkV2lLX7bt7mR/y9WWhUGFjzi/YxzzrAgziQtqwVNznMZvQ47KrqAmboKnXVxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FSkHj2RV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cUb6Cun/; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FSkHj2RV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cUb6Cun/"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H9LQiZ1461966
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 09:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Byke9lF7SSp42L4/+Y+WzY4ZS/QRpxLv4f6tPfcDO5Q=; b=FSkHj2RVHfNGNFyd
	Tvxff00A7KexF3nP6J0PBeyrg+IIvYiduSLB2nZ11464CQK8gbTqV3IthCYJX76X
	FQVq6IhdeHdS7IlSJFMq1DI9E/ytGMPOfqEMgLY36JNcsVns67IPLKQ7Ue8wTFuF
	y3R3UCZ2NTHczYBRJuqPz9P4Z6Jpjt9WNBSBZlWFo52VsnsE1/Y9atJ6O/+1rAi2
	sw/xQlZe0miL+pMuOxjBN7M/E7rSVw7YddpPYRiN24bvIJxnUhxSj3pMUzA5N1+g
	DNhPoD6qVYblUiYyZhJR2L3GDcuefsLw0F3NcWo+TN6Dlzs6ZaE6jZa1WiLoOQRo
	QRjtKQ==
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffhpfg21f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 09:38:43 +0000 (GMT)
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-6681d22f70aso4477631d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784281123; cv=none;
        d=google.com; s=arc-20260327;
        b=r48hNqgJDGn6ODo+9+F7dZrpCfkNKbXcD2pElTKyPB3u+sTVmIGs/Aq8T4e1mLwyvn
         xrPnXD3cBphPJANXnw+55GjpeUlalqEwDiElA8YpOj1B+FhMN0N1KOsHGqWx6r0lsJeV
         9Heg6gK/h3XAnuBW2V1B1dCPgulhqIu58WULkeoCvBjCnBWL9g9KUmNNdY2WXqgM/0lO
         eP456MO3vDGuQFGlJKnbPwKAVIUdDXu02o1y5o+zzL6qF8NtuUPKU0EUPOPlVUyvvE/T
         e11iLKjQc7Dp6DsbEwEQXj0WFM7p3VRXd4d5kxxyYj61sOgNmGW+vA5E2V7IO8sj42Rp
         Z2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Byke9lF7SSp42L4/+Y+WzY4ZS/QRpxLv4f6tPfcDO5Q=;
        fh=JTgGO2B0J1+IWj2HeEz2aKCRcrsKlk5mjJ761jAORGk=;
        b=VTI7CQY8mfX/C7194nr5HpTz1SYl3b0YhoHKHKUsAqIE/w81FbOrLEZjiayJzhhB+1
         GqC/lZSb78SVJNNmjNCd+RSgJowQ9I7+y1JO+xO3YZ08B3LkTONloWJZiYxk3MuUomuX
         ZcSVIkrBdeYSCLfn5bVwXaxM8a9FPXXlcYYxHpS7qRBJuaM5lgXAmDOEO9FtUuseJ+uq
         7/4wU7EatSUaSKd36UULJWPYJb67//8N1+djRyqPB0gj6vI4zNiOK8kyorDpEq0YN06g
         V7isr8oBid2xApIwG5jc+hp7bWavFxSwKhkg8bA/pPytnBIPJqCzc8g8NGY26t0IL334
         MWMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784281123; x=1784885923; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Byke9lF7SSp42L4/+Y+WzY4ZS/QRpxLv4f6tPfcDO5Q=;
        b=cUb6Cun/ssj6PiWGf0oax9hSYRaqFW0IOvaodmJpfa813y0BX13MDEvz8ycjWprisf
         IpmS4a5UXUXunr3Cv+TMmZqewf5JYLW5upV0zajfnUEj9Bf4K+SJOzg+Y1lRqNe4Hy/C
         XizFB6M+R5L7oP8rre4Yn15F2acsKvzUxt4aGx4vnnXHEhZtb+OnsliRVHgapPKoE6cb
         CFZ+qOg1HbwSpnZnXGpt9CyOLxC91cGrR/Xlod1X11jHuOV0JAX92y18/B0f4xoK1076
         sfs81++XDGnyeqEHUC/F6wFlv6pGR2P+wianReOioNegJVKXt4m9FSpGWbHt0JralSu7
         QWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784281123; x=1784885923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Byke9lF7SSp42L4/+Y+WzY4ZS/QRpxLv4f6tPfcDO5Q=;
        b=I7QU5K8fXDS4OChwAYQofcmaHVaN911FyTzQIZBm75JQcvhTU5CijfBt3UQX2zqVuc
         VjrGY0sUD/RrWHIAIkoj85H59TeE/XGJspb4TjW/B13m6waBJNEgU2oTSQTWejN62BxH
         +FmcTdM5oOGWo+ZVLKn3aKIUamTw8jFB7eACSEP1FZtC63IoecZ5oLoWBolm+JMaUL3U
         r3X28G446S5RW3NXnh6E7bfUOR8hUvaSwdpWn/l/ls3JIIpVbeZd3Cx1MZJCtAPKYP4j
         5NY7nIeGNmcFRku57//uwpHhZqxNr6gbH0Nan2YRP8ScdlReC0bSoCWBgCDEbU3gGv/F
         yeuw==
X-Forwarded-Encrypted: i=1; AHgh+RoDUiK3v32eBzvi0CsJL/9i6084p3zLUhmXNQtKSnut/LRTaQ6fmWEQES2mHdDqNocR3cxKxJFzmqYh@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwmk388ZY0cPxd3EibWX6g6pDrsPraIjRGncnXGyZRnBMm2SNI
	51UOffA+RVB7V++0RfkBInDEiod/gl80R0O/lmBphmCJNrX4UWgxec6lAAw5qebm9rWAKE1OTE5
	OWITRjkUXIV3ArIh6U0KckxZEzilWmu5lqQU6tdgweHNxL+jyRulbptbUZYz2jyawDR/AwwFCur
	sEi39R1zdM/nKJ6SJZzroMhHMTp75yfzH4VwLlXI4=
X-Gm-Gg: AfdE7clErnxFgdY3OkJqyvV97CfdDm6nwZERGRyDKsxgfnATShr/Q66CHSkViWPDdJQ
	pf0AhDwAQG1IaV27G4aBas5c4YCGIPYYdJA2qf/b9mkx1kXAJvp/jZ++q/xFma2RuEOSSJKMm7S
	zTpfJ3aI6E4AeObFDwpmUgrkHNQkLpH+TBhItpAgkkcOWY9f+yO/AgWsg=
X-Received: by 2002:a05:690e:13ce:b0:667:daee:17ee with SMTP id 956f58d0204a3-6683bb79a33mr442039d50.39.1784281122906;
        Fri, 17 Jul 2026 02:38:42 -0700 (PDT)
X-Received: by 2002:a05:690e:13ce:b0:667:daee:17ee with SMTP id
 956f58d0204a3-6683bb79a33mr442029d50.39.1784281122363; Fri, 17 Jul 2026
 02:38:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com> <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
In-Reply-To: <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
From: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 11:38:31 +0200
X-Gm-Features: AUfX_mxVDZM5kXu-CrAEkInMj0hjSBk8LzLzD_taXmZkxBvbyWjLlJY_ZY3mexE
Message-ID: <CAGgiveXtErFjDgxN9reR7s705U3wnnH65c4Su06ZQz_7EYwzuA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA5NiBTYWx0ZWRfX8P9Q4XLdOOYp
 f7yC18Fb4N2ivMffbVxLhPeykzXbXtku3GRPNq0t5KIb3vwyYdBTpeL9ayWWJ0NTsfG4lRWwmuI
 6pVjaYZ58GMP3+R8lSUdxkEcTVZN51g2pzDf87lfn3A8ECUv+Hlu5hJmkABlwgVNmbURqtvOS+H
 sHkrhgjIV7qTVZYvkms+tJiWNTOgrAPtfmfMlJmTyGLjKIiKP6tm9cTV/fqySH0e8mwKJaODJTX
 u+nO0JYUNmFDSX0OhI4ouUYBoMAyDKjpOPuJp7+JegJlEDTYLDNumqtcADBRD8/LBbLzYKtvo46
 c65AZsavtSGQYsUQKrRlrm1L6xAIohqrfLKt3vleGpshWeWKtY/ieQ2J3gLDB4rlkbHrwJyw8qu
 uTe1XRyfNcTCysL3yMwt2cX6zQ18h2nMVpSfhO9y6Jje8ykB4hjfepGRF+rA3alVWfFiHSuQ/P8
 e+ewQNchVzCuJVwmyVg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA5NiBTYWx0ZWRfXyMR4yTfDVRKl
 vLhg3BFFAQSRBTo3e3l3dS4IBwOuXHcqb2bpG8iWRa3c5FGXTfxf0K5cxSCquv+QDGB8LnO6vDh
 TH1h3mNsTsI9OCWl962arzJUitRcvGQ=
X-Authority-Analysis: v=2.4 cv=YeWNIQRf c=1 sm=1 tr=0 ts=6a59f823 cx=c_pps
 a=S/uc88zpIJVNbziUnJ6G4Q==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=NEAV23lmAAAA:8 a=EUspDBNiAAAA:8
 a=xHNurQw6US8NauEldhQA:9 a=QEXdDO2ut3YA:10 a=nd2WpGr1bMy9NW-iytEl:22
X-Proofpoint-GUID: 6Vvz32zAdw8ryaD4eRtKSOFg2Gbv2cfX
X-Proofpoint-ORIG-GUID: 6Vvz32zAdw8ryaD4eRtKSOFg2Gbv2cfX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170096

Hi Jorge,

On Thu, Jul 16, 2026 at 10:37=E2=80=AFAM Jorge Ramirez-Ortiz
<jorge.ramirez@oss.qualcomm.com> wrote:
>
> The RPMB authentication key is derived from the dev_id handed to the
> RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> is the eMMC CID, a fixed 16-byte value, and it derives the key on that
> assumption.
>
> The UFS RPMB id built here is "<device_id>-R<region>", which is variable
> length and longer than 16 bytes. Passing it verbatim would tie the
> derived key to a length OP-TEE does not expect and diverge from the
> fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
> UFS ids.

Yes, if it's possible, It's nice to avoid that.

>
> Hash the UFS id into a fixed 16-byte dev_id with blake2s instead. This
> keeps the derived key stable and unique per region while matching the
> eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
> identical and no OP-TEE change is needed.
>
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
> ---
>  drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index d0c7ea7a36f4..b800871269bb 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -10,6 +10,7 @@
>   *     Can Guo <can.guo@oss.qualcomm.com>
>   */
>
> +#include <crypto/blake2s.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> @@ -21,6 +22,7 @@
>  #include <linux/unaligned.h>
>  #include "ufshcd-priv.h"
>
> +#define UFS_RPMB_ID_LEN                        16      /* Match eMMC CID=
 Length */
>  #define UFS_RPMB_SEC_PROTOCOL          0xEC    /* JEDEC UFS application =
*/
>  #define UFS_RPMB_SEC_PROTOCOL_ID       0x01    /* JEDEC UFS RPMB protoco=
l ID, CDB byte3 */
>
> @@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>         struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
>         struct rpmb_dev *rdev;
> +       char *dev_id =3D NULL;
>         char *cid =3D NULL;
>         int region;
>         u32 cap;
> @@ -213,8 +216,17 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>                         goto err_out;
>                 }
>
> -               descr.dev_id =3D cid;
> -               descr.dev_id_len =3D strlen(cid);
> +               dev_id =3D kzalloc(UFS_RPMB_ID_LEN, GFP_KERNEL);
> +               if (!dev_id) {
> +                       device_unregister(&ufs_rpmb->dev);
> +                       ret =3D -ENOMEM;
> +                       goto err_out;
> +               }
> +
> +               blake2s(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LE=
N);
> +
> +               descr.dev_id =3D dev_id;
> +               descr.dev_id_len =3D UFS_RPMB_ID_LEN;

This change will break current users of this interface, if there are
any. There are currently no upstream users in OP-TEE since you're
adding that with https://github.com/OP-TEE/optee_os/pull/7881, but I
suppose that's not the only use case.

Cheers,
Jens


>                 descr.capacity =3D cap;
>
>                 /* Register RPMB device */
> @@ -228,6 +240,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>
>                 kfree(cid);
>                 cid =3D NULL;
> +               kfree(dev_id);
> +               dev_id =3D NULL;
>
>                 ufs_rpmb->rdev =3D rdev;
>                 ufs_rpmb->region_id =3D region;
> @@ -240,6 +254,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>         return 0;
>  err_out:
>         kfree(cid);
> +       kfree(dev_id);
>         list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
>                 list_del(&it->node);
>                 device_unregister(&it->dev);
> --
> 2.54.0
>
