Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F38C31A803
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765918443; cv=none; b=osJGXqYPdyvMf8Jp9iC134uG6EyhLfLcgLhk+6JDmX1lEUpr9rIqfFmt2993OAn02otc56P927SnWH3S+YpVyxreJPj3bX+wP2u6ptjigz41NN9AF+Qd9JI70dkt9oJ6kY/MI0mwN/cTBNGmh/nnvC6DIk6DBu3SXXJoxRmj6Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765918443; c=relaxed/simple;
	bh=aKsVqB3kbdd2VxBI1AcgLQpf8IlVr10uDuGqdRTTNTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHUCbA4oY7XUnNxY69aUOt3gpi9TEC3HcII8g92cUmqciObPbwLdDlrEbW0+e/BFy5jghoBXnd/LLsxUTUdp2TTx+v/l5lOeSkwhkUANiF5waPI/3NLqxjSwI/OnkSnn4MXHCpgJpCNXnr3kmDwZB1KT5upgPk0KwjugShIiqrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0422AdmE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0422AdmE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dW8Kz3qp3z1XrWbh;
	Tue, 16 Dec 2025 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765918437; x=1768510438; bh=PKT+d6JW3wUQ7ExiP7NK4/NG
	XbxlsaW+Ci/7RqJyNyQ=; b=0422AdmE5BsW5UGS4WfAz8g+HWAwO0ydR2q/CMJI
	fEGCzCeFXKWq0SbKLX+9Q4V12+bq+wcAfFBwqfrMRjS+Tbpvl/r9FzU5qpEh5Llq
	+11ZLfvyKHrJRJQf+U3WB3ZcVKZlSzyLvf+TtlOcLb+PAwuUd17g6PuP7/BIm2ud
	skanvvUpQLkpdZOw27dxpzWO/uChp3DY839Ahdu4P+UStRev35+61Mo5t8FnnTu0
	kWrkFtZtFU6Fp21rcuuCq1UE0B6Oywi8jJKkqPui+yY72NFJfgw9nnpQcuNYKIoX
	JnBNhl79Gc/eQ4MWHFHvRIBU5TsUrrAWZe8IhedSXvCIqA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jIN6xClppPwQ; Tue, 16 Dec 2025 20:53:57 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dW8Kw0lcqz1XrWDY;
	Tue, 16 Dec 2025 20:53:55 +0000 (UTC)
Message-ID: <8bd59ca3-ac8a-4bc3-af5b-ba48000fb0ad@acm.org>
Date: Tue, 16 Dec 2025 12:53:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
 Nitin Rawat <quic_nitirawa@quicinc.com>, Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <014c3e26-24ea-40e3-a876-bf0336231b18@quicinc.com>
 <3bcc40b9-5085-471b-85a9-259ec25c5c0b@acm.org>
 <aa40a658-f036-45ad-8d7c-e133b3003748@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aa40a658-f036-45ad-8d7c-e133b3003748@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/4/25 6:36 AM, Nitin Rawat wrote:
> However, the UIC error persists, causing the error handler to run on=20
> every boot. The behaviour is same on both SM8650 and SM8750.
>
> [=C2=A0=C2=A0=C2=A0 3.516236] ufshcd-qcom 1d84000.ufs: ESI configured
> [=C2=A0=C2=A0=C2=A0 3.516272] ufshcd-qcom 1d84000.ufs: MCQ configured, =
nr_queues=3D9,=20
> io_queues=3D8, read_queue=3D0, poll_queues=3D1, queue_depth=3D64
> [=C2=A0=C2=A0=C2=A0 3.516275] scsi host0: ufshcd
> [=C2=A0=C2=A0=C2=A0 3.584233] ufshcd-qcom 1d84000.ufs: ufshcd_err_handl=
er started; HBA=20
> state eh_non_fatal; powered 1; shutting down 0; saved_err =3D 0x4;=20
> saved_uic_err =3D 0x40; force_reset =3D 0
> [=C2=A0=C2=A0=C2=A0 3.607898] ufshcd-qcom 1d84000.ufs: ufshcd_err_handl=
er started; HBA=20
> state operational; powered 1; shutting down 0; saved_err =3D 0x4;=20
> saved_uic_err =3D 0x40; force_reset =3D 0

Does the patch below help? This patch is sufficient to solve this issue
on my test setup.

Thanks,

Bart.


Subject: [PATCH] ufs: core: Configure MCQ after link startup

Commit f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
did not only cause scsi_add_host() to be called earlier. It also swapped
the order of link startup and enabling and configuring MCQ mode. Before
that commit, the call chains for link startup and enabling MCQ were as
follows:

ufshcd_init()
   ufshcd_link_startup()
   ufshcd_add_scsi_host()
     ufshcd_mcq_enable()

Apparently this change causes link startup to fail. Fix this by configuri=
ng
MCQ after link startup has completed.

Fixes: f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
Change-Id: I59754fdd910b9a88bdd681280342b923c4c494b0
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/ufs/core/ufshcd.c | 7 ++++---
  1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d18a3e616c8a..310fd3fa0897 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10812,9 +10812,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
  	if (is_mcq_supported(hba)) {
  		ufshcd_mcq_enable(hba);
  		err =3D ufshcd_alloc_mcq(hba);
-		if (!err) {
-			ufshcd_config_mcq(hba);
-		} else {
+		if (err) {
  			/* Continue with SDB mode */
  			ufshcd_mcq_disable(hba);
  			use_mcq_mode =3D false;
@@ -11088,6 +11086,9 @@ int ufshcd_init(struct ufs_hba *hba, void=20
__iomem *mmio_base, unsigned int irq)
  	if (err)
  		goto out_disable;

+	if (hba->mcq_enabled)
+		ufshcd_config_mcq(hba);
+
  	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
  		goto initialized;


