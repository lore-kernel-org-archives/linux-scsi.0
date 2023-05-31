Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10728C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 22:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjEaWW5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjEaWW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 18:22:56 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5F19D
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:22:55 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-62626bf02f4so594126d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685571775; x=1688163775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nl3h0YcjaczrpJ4lLQyJhbcAfs7rgj2ERto9s2Uqm3w=;
        b=HsvZbP97y6MHzfSdqT8/K0km/IeeTyrpyo9rrZXeRn9ywDxt1pdNqL+SRJ/i5sbZPq
         pxsN6pk0zJPWcjG50kIyFQ6k48sGaO8C7TvGwo4eyBfaMuJa/Fglgms8YW3nrU8Moq2l
         No9t+16iMpEJjMX1F4yAzP3kO38izHgUKlSRDmxgCUMmeku2IvZPczTS7uF8PBzTyPy6
         0t/WTjt9bWf1TCBeIajUARmGYPx9cszRS27u/k65Js2gIrEpXoGLnTCgdIxbxgWJnCfm
         5rjkztmp9RwYhPYaPn1iRBdLu1vLcinFuIEUuXhODuu418773XwA2KHrEgtan6C0/A0O
         PAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685571775; x=1688163775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nl3h0YcjaczrpJ4lLQyJhbcAfs7rgj2ERto9s2Uqm3w=;
        b=JHb6yEHSoBoVBYr3TOXbVWTGN3yaD6jochexFWZv4sv+ih+8D3X3zfHhkEwb+4bXTk
         GQ8hCUTohAhU3yfXPfn6//OSJKj7LjA6BdusK+sYTl0fxrwM+DXlWOEv80dlnPVaZwT3
         525nOAHopoiXNhG/DGXnxZaiqZ3ZdK5VdqB4BYOqgkkL6eEN0YKBOe33KctFfmEr+Zlz
         7BA4Q8sBuJFVafKFEVSBOvR5mMBYS4i95d6OzwOgda+/m/KqQDnwY8imtSCyWXkri34p
         USNlxS53reYWY3X/kizvo5idhsd/HpIluD2cz97BWwTj1Y14YYBI7G3XdXtWn0lGbw8O
         RpFw==
X-Gm-Message-State: AC+VfDz8OqbY2hJYjmjYiwTIHxL8wyncmR0yv4KDJ7to2VhCmLo79RNQ
        WarENVScK7D7XBAZ1uKoGDYDaZqMDA4=
X-Google-Smtp-Source: ACHHUZ5TpSm+rCcBCq4tg/uxAAuBL7VCQgsQlzYc2PX9M1ijyb/FC4Ltp5RABJniECzS3aS9DhN/kg==
X-Received: by 2002:a05:6214:76f:b0:628:268c:1d72 with SMTP id f15-20020a056214076f00b00628268c1d72mr3282942qvz.5.1685571774804;
        Wed, 31 May 2023 15:22:54 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g12-20020a0cf84c000000b00628274a709fsm1151610qvo.47.2023.05.31.15.22.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 May 2023 15:22:54 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3][next] scsi: lpfc: Use struct_size() helper
Date:   Wed, 31 May 2023 15:33:19 -0700
Message-Id: <20230531223319.24328-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prefer struct_size() over open-coded versions of idiom:

sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count

where count is the max number of items the flexible array is supposed to
contain.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
Changes in v3:
 - Instead of hardcode to 1, use be32_to_cpu(rap->no_of_objects).
   (Justin Tee).

v2:
 - Use literal 1 in call to struct_size(), instead of rap->no_of_objects
   (Kees Cook).

v1:
 - Link:
   https://lore.kernel.org/linux-hardening/99e06733f5f35c6cd62e05f530b93107bfd03362.1684358315.git.gustavoars@kernel.org/
---
 drivers/scsi/lpfc/lpfc_ct.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index e880d127d7f5..703429512ead 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3748,8 +3748,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
 		rap->obj[0].entity_id_len = vmid->vmid_len;
 		memcpy(rap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
 		size = RAPP_IDENT_OFFSET +
-			sizeof(struct lpfc_vmid_rapp_ident_list) +
-			sizeof(struct entity_id_object);
+		       struct_size(rap, obj, be32_to_cpu(rap->no_of_objects));
 		retry = 1;
 		break;
 
@@ -3768,8 +3767,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
 		dap->obj[0].entity_id_len = vmid->vmid_len;
 		memcpy(dap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
 		size = DAPP_IDENT_OFFSET +
-			sizeof(struct lpfc_vmid_dapp_ident_list) +
-			sizeof(struct entity_id_object);
+		       struct_size(dap, obj, be32_to_cpu(dap->no_of_objects));
 		write_lock(&vport->vmid_lock);
 		vmid->flag &= ~LPFC_VMID_REGISTERED;
 		write_unlock(&vport->vmid_lock);
-- 
2.38.0

