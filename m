Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11CF209F56
	for <linux-scsi@vger.kernel.org>; Tue, 15 Apr 2025 03:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744687178; cv=none; b=arVhkQqJRPv0grQdt/ka9XjMMBfbEjgQVW0+61NTlf9nWja7PSfndwTZMrltQ3Tw/TNrv90/cwhZyqq0yTMoWJwOkLfQpqxrNVYVhQAkFD9fU1N+ZS+xfjm+DvieVSGiYURcSNB+CWBYPThaWOBj1LXayfXCX8KEgLC5b/1BISo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744687178; c=relaxed/simple;
	bh=0BjICqzVc+w7m22nLm/uANpHZbJCTJzdUiwNMCa7JCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PH+d78OqhsYTWlEqSxJ8ahdsxvvJ2iCr/hJlvPKz9GRJqsGcLDJIgOZCD5cwu4l8e5/zF7FbpT7eVuxiaywjAxw0jA2ckAOHIFurv+P76WZcDXRi91uVCROhH813Wtnf5SfBBjJM/qsuv2jHzI+ysjuhRDYjcGSraMwKRQOEnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-03 (Coremail) with SMTP id rQCowAAHtEA50P1nPe_vCA--.15558S2;
	Tue, 15 Apr 2025 11:19:23 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: gregkh@linuxfoundation.org
Cc: Thinh.Nguyen@synopsys.com,
	bootc@bootc.net,
	chenyufeng@iie.ac.cn,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: Re: [PATCH] drivers: Two potential integer overflow in sbp_make_tpg() and usbg_make_tpg()
Date: Tue, 15 Apr 2025 11:19:11 +0800
Message-ID: <20250415031912.1626-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <2025041025-cozy-pug-fa22@gregkh>
References: <2025041025-cozy-pug-fa22@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:rQCowAAHtEA50P1nPe_vCA--.15558S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF18Xr15uw4UJw1fCF13twb_yoW8Gw1kpF
	4xt3Z8KFyjyw48Gr1xZws8Jr18Grn2vr95tr4ft345W345GaySkF97KrWUZF47AryrWa12
	qayYv3sYy3WDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUoKZXUUUUU=
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBwoNEmf9owK-yQAAsf

> On Thu, Apr 10, 2025 at 10:05:49PM +0800, Chen Yufeng wrote:=0D
> > The variable tpgt in sbp_make_tpg() and usbg_make_tpg() is defined as=0D
> > unsigned long and is assigned to tpgt->tport_tpgt, which is defined as =
u16.=0D
> > This may cause an integer overflow when tpgt is greater than USHRT_MAX=
=0D
> > (65535). =0D
> =0D
> Can that actually ever happen?=0D
=0D
I'm sorry, but I haven't tried to trigger this vulnerability myself.=0D
=0D
> If so, why not just fix up "tpgt" to be u16?=0D
=0D
It's certainly possible to change "tpgt" to u16, but even with that =0D
modification, UINT_MAX should still be removed, as this limit =0D
would become meaningless.=0D
=0D
> > My fix is based on the implementation of tcm_qla2xxx_make_tpg() in =0D
> > drivers/scsi/qla2xxx/tcm_qla2xxx.c which limits tpgt to USHRT_MAX.=0D
> =0D
> Again, why not restrict the size of the variable to start with?=0D
=0D
You are right. directly restricting the type of "tpgt" will be a better =0D
approach.I will take your suggestion into account in the two upcoming =0D
separate patches.=0D
=0D
> > This patch is similar to=0D
> > commit 59c816c1f24d ("vhost/scsi: potential memory corruption").=0D
> > =0D
> > Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>=0D
> > ---=0D
> >  drivers/target/sbp/sbp_target.c     | 2 +-=0D
> >  drivers/usb/gadget/function/f_tcm.c | 2 +-=0D
> =0D
> You have to split this into two different patches as it goes through two=
=0D
> different trees before we could take it.=0D
=0D
Thanks four your reply. I will split this patch later.=0D
=0D
--=0D
Thanks, =0D
=0D
Chen Yufeng=

