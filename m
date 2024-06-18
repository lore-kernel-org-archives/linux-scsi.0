Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA5A3F
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 01:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718675109; cv=none; b=JUt9Je4wanXJ19nd4KCE7VjbPWEvg1DmaHVBJc4/8dqXRmDGPZKT9XzyaVO/SS/MJWKmZVIqkKLxs6eoozE8fK+JmHyZyAc6LSpuWaXMXv55VlfPEaI+naDfCoT3GF91fGaHsQquAn1NparLV4B45iePFzi+HzcudpnPsqnYerg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718675109; c=relaxed/simple;
	bh=ptWWHCu9RqkbtHxNFXs5GRs8/2F0/hnzxxSkC5q0yJs=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=fcWICYtpk/o2h4mbUAsBsho9RFObFOtWjunjhHVd2dDSfoSMNZPOOq73OsqFR9Zy2Auq8wL+mfeq+gh/23Ai+5EoWbUFBQo7Q5rcCJ7rczAO0aLj5r7EXEHhtN6QVvExqTVS2GdrIoKGKleoGtvHPN1TH9pGA1KKd1l/863hPTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PeZ4njCB; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PeZ4njCB"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240618014504epoutp019dcb136d5b9e79a49ed9422d9f01e5e9~Z9ea3kiJ_2636826368epoutp01F
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 01:45:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240618014504epoutp019dcb136d5b9e79a49ed9422d9f01e5e9~Z9ea3kiJ_2636826368epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718675104;
	bh=ptWWHCu9RqkbtHxNFXs5GRs8/2F0/hnzxxSkC5q0yJs=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=PeZ4njCBaYNgNitlcEp8zdwxo7WQ/8c6Vx6cRryNa5iw20bCIDa4RC4DIkEBiV2qY
	 qkhbNuO0h7DyoYNGJQyRBkKATdrJmpWIZa9baMqZ8cz/a6hyo0C2TcsZe3SRWBe71q
	 Svq/0hZK0sF+qBLjKd0HM015rukHHNWP98ktRLlY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240618014503epcas2p4d8f5c4c6978eaa836afffb7384de2434~Z9eZ6Tzuq0615806158epcas2p4Y;
	Tue, 18 Jun 2024 01:45:03 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
	(Postfix) with ESMTP id 4W38hH01Xhz4x9Pw; Tue, 18 Jun 2024 01:45:03 +0000
	(GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Minwoo Im
	<minwoo.im@samsung.com>, Peter Wang <peter.wang@mediatek.com>, ChanWoo Lee
	<cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>, Po-Wen Kao
	<powen.kao@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
	Sadhasivam <manivannan.sadhasivam@linaro.org>, Maramaina Naresh
	<quic_mnaresh@quicinc.com>, Akinobu Mita <akinobu.mita@gmail.com>, Bean Huo
	<beanhuo@micron.com>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240617210844.337476-5-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <252651381.21718675102994.JavaMail.epsvc@epcpadp3>
Date: Tue, 18 Jun 2024 10:28:40 +0900
X-CMS-MailID: 20240618012840epcms2p76947bf9acd2eb447be010ec7cf9d1416
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20240617210952epcas2p33dbf2b725c4061894f7453671b4298bb
References: <20240617210844.337476-5-bvanassche@acm.org>
	<20240617210844.337476-1-bvanassche@acm.org>
	<CGME20240617210952epcas2p33dbf2b725c4061894f7453671b4298bb@epcms2p7>

Hi Bart,

> UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
> the maximum number of supported commands in the controller capabilities
> register. Use that value if .get_hba_mac =3D=3D NULL.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/ufs/core/ufs-mcq.c 12 +++++++-----
> include/ufs/ufshcd.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 4 +++-
> include/ufs/ufshci.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 2 +-
> 3 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 0482c7a1e419..d6f966f4abef 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -138,7 +138,6 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
> =C2=A0 *
> =C2=A0 * MAC - Max. Active Command of the Host Controller (HC)
> =C2=A0 * HC wouldn't send more than this commands to the device.
> - * It is mandatory to implement get_hba_mac() to enable MCQ mode.
> =C2=A0 * Calculates and adjusts the queue depth based on the depth
> =C2=A0 * supported by the HC and ufs device.
> =C2=A0 */
> @@ -146,10 +145,13 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *h=
ba)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int mac =3D -EOPNOTSUPP;
This initialization can be removed.

>=20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!hba->vops !hba->vops->get_hba_mac)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0mac =3D hba->vops->get_hba_mac(hba);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!hba->vops !hba->vops->get_hba_mac) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hba->capabilitie=
s =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mac =3D (hba->ca=
pabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mac =3D hba->vop=
s->get_hba_mac(hba);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mac < 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err;
>=20
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index d4d63507d090..d32637d267f3 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
> =C2=A0 * @event_notify: called to notify important events
> =C2=A0 * @reinit_notify: called to notify reinit of UFSHCD during max gea=
r switch
> =C2=A0 * @mcq_config_resource: called to configure MCQ platform resources
> - * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq mode
> + * @get_hba_mac: reports maximum number of outstanding commands supporte=
d by
> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0the controller. Should be implemented for =
UFSHCI 4.0 or later
> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0controllers that are not compliant with th=
e UFSHCI 4.0 specification.
> =C2=A0 * @op_runtime_config: called to config Operation and runtime regs =
Pointers
> =C2=A0 * @get_outstanding_cqs: called to get outstanding completion queue=
s
> =C2=A0 * @config_esi: called to config Event Specific Interrupt
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index c50f92bf2e1d..899077bba2d2 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -67,7 +67,7 @@ enum {
>=20
> /* Controller capability masks */
> enum {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0MASK_TRANSFER_REQUESTS_SLOTS =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x0000001F,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0MASK_TRANSFER_REQUESTS_SLOTS =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x000000FF,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MASK_NUMBER_OUTSTANDING_RTT =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x0000FF00,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MASK_TASK_MANAGEMENT_REQUEST_SLOTS =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x00070000,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MASK_EHSLUTRD_SUPPORTED =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x=
00400000,

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
