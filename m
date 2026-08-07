Received: from mail-lr2-f11.google.com (mail-lr2-f11.google.com [74.125.230.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9891C3CB544
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 09:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786094344; cv=none; b=EBvEwQQxWTHyjHO7RBz1CpDscvyfSDmhFZBZaoTofNKf1shLViT+4WwwOooM2iNhN9vjaSHNeqA+Yz3n6093SNQ+qhC75ow2p42v9HYeeWW5peFbBCGc6/UJ3O0v9tOc9aKTUs5XAuutJ4GniJEx6LVRyi135Wn1UoVKANBjLkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786094344; c=relaxed/simple;
	bh=t9Lm5Q/A2wiqcLU589YGQrHAVCaBgRmTAHdTIxzVTzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pd3Ts+gcGWPZIPNLh8YRegAl/zyqaIPFeqaRwH3EyI649PSnLagu0Z/0yR77o9mcW8smUYEAVIPOvwck4EOoEgsNp8qUehtkTF58d0+Pz2mbj/xIQqhxbAiWEHKGRpsz5dtBrz7FG7JwhtAGjvKhXrnU7JGmvI8nkTQjLZlJS/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbuD67Xz; arc=none smtp.client-ip=74.125.230.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbuD67Xz"
Received: by mail-lr2-f11.google.com with SMTP id 38308e7fff4ca-39c6d9f787eso16392551fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2026 02:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786094341; x=1786699141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q0p3f/CYZv3LvBsxpZaJPm4mZZTrcQzfNJYPhxpBa2M=;
        b=LbuD67Xz2dtODUggoQdbKvZ32eh/yTmqcHhMExHS1QJ/09GbBd8NNGS1GWBjyn4Ogy
         fMEVCFZdT5JamO8eiNjsyM8HgGWJ75k0uwtHK1lNMeT/k0GnSbRxAnaAFwgkMAIRxQVz
         t7cq5zt2rM8aXbc9hJhW+1mUXZYld2HSaVJS+ja8CJPAf+KXedplFnTFf1YscCTpilZ0
         QyzPwWl8H9dUxYYSrAg6olFmz5mynyDcTvNNATxfzSwYF0AwOaa8X5Mhj7oA8OUlcpYZ
         v6YKBWxqbjgcBi6jesMnfYequHjKhnH1IoyyeDsdyGUAdvBkkUnfZwJ0hPJbD7f2b7Yi
         J0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786094341; x=1786699141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q0p3f/CYZv3LvBsxpZaJPm4mZZTrcQzfNJYPhxpBa2M=;
        b=J/O42KhLp4KyI3PovJYz9eGQ89Rtu8ZT0UpIvGWfSlVbX7iVV0B3RlLPi8tbyZn3e6
         wQbs5Px9LBFtCEXB6OC2Jm8wqfheaHnqqUqukOhCWyRasqT5+69f1rA2bt6WlF1bQG6g
         cJSAlaGeL5W2kzV35DTNLZImBVJ872wq49HWDWzVYzNE23qjVgC5QV28USP1e27gDbPR
         4dFwkec32Cjx6W0FsBPjipdg2f8uc7FrB+zyPtl3NEPXbsnybtTDCmn6fCF6yjMgDvEk
         PQXIxPRbuXP2PXzvYfILDAFtfDjnouuMNC76XlGCgFFK9qZCg+r3O/GycAYmf7Ql+gCg
         J/9Q==
X-Forwarded-Encrypted: i=1; AHgh+RoFcmE3Lq34xns+cm905LGtO4erE3vFkPJJ6p0+wWpT7JoWNHmMK1uqG2icNlVUuLckVXgn2YYai6P8@vger.kernel.org
X-Gm-Message-State: AOJu0YyvSb490czZ0D85im/ze9QFhqUg8fugabvrwzubvmqEw+bND1cM
	jsQQPLtFKzE64N4BZdOg/a1+jtiqoIP6X0LKoN/FwdGsP3PRPxfEu2Gl
X-Gm-Gg: AR+sD12l1TWUabL4Ti9LTw0c0AYkklCBTuLtVam0MyNgh90omo73/Fi9xlezhBoNwzK
	1NYVz9E4vIEqtnRzLICc3TgCRFp90ZDWz0IleNltvLb+SH1gbqAs0jipDo0+D+GBTUfGWB6C9NZ
	emoaytUoQbHta8zxeqobGWthWCRK6zwrDohVqllWHyOXM00m2P+ZNIYe2g+SXiTvfb1vrXyXfUn
	cEjdV0cvR9tt2Jh4D24Laz/hcMUbW5xqG8oN+5/BfchCtRPrvklUZ0XBJGHXRe5swJW6SpCneui
	qx1zaK4+hWsoBOr3hKCyktDMVMag/P5e/7Sz4Q8ok4t5N6EYgKup2HpnohB3GVPCBPhf8Ou0hDW
	6au5w9XxRI2ZheXNucc9VvGWYftI9SKsCu6v1+yypny2noSd1dMlh7SM3bRav37vZjpwQWJXe8S
	mPfgISiy62ZASSHiq+aV+cSuluP2jJndxm5YFXHMUA9hxBraNE8L1ewbqOM3E3MC4FWmsz6OraN
	6x1bQ==
X-Received: by 2002:a05:651c:210d:b0:39f:b1f9:327b with SMTP id 38308e7fff4ca-39fd68db3damr7183621fa.31.1786094340316;
        Fri, 07 Aug 2026 02:19:00 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39fddd52594sm2370361fa.25.2026.08.07.02.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:18:59 -0700 (PDT)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: Satish Kharat <satishkh@cisco.com>
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] scsi: fnic: Fix invalid comparison for error
Date: Fri,  7 Aug 2026 12:18:50 +0300
Message-ID: <20260807091852.13151-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current comparison err != ERR_ECMDUNKNOWN is useless because err < 0
and ERR_ECMDUNKNOWN == 5. The logic is that if the CMD_CAPABILITY
command was executed, there is no need to respond to unknown errors.
Therefore, the sign of the number in the comparison must be changed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/scsi/fnic/vnic_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 991c86eb5aff..0e5ae0540d85 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -381,7 +381,7 @@ static int vnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 		if (result->color == color) {
 			if (result->error) {
 				err = -(int) result->error;
-				if (err != ERR_ECMDUNKNOWN ||
+				if (err != -ERR_ECMDUNKNOWN ||
 						cmd != CMD_CAPABILITY)
 					pr_err("%s:Error %d devcmd %d\n",
 						pci_name(vdev->pdev),
-- 
2.53.0

