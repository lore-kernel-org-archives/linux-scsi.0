Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACAEC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 11:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AED761251
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 11:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbhIYLo1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 07:44:27 -0400
Received: from mout.gmx.net ([212.227.17.22]:51637 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241912AbhIYLo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 07:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632570146;
        bh=tj1T55xR/yg8xao0p750/JK6a19FeyQYkhFZlEM80pc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=jIsIs4oIra5zoQsfYzRy6F4QZD2C/6eAFwaShOZRpXADzua2xqwm1Q56zv0WB1Uym
         5dEotaWyrd1Uab2clsKVMZU1jkkkZraGmXlkHMS3eaSAYY562PuIEbMndcTC+fxylz
         p4l2fYSChrer/N7RUKzVDj+0jCLPRufho5OjnZa8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MCsQ4-1mcvlB2qMC-008u6J; Sat, 25 Sep 2021 13:42:25 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Len Baker <len.baker@gmx.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: advansys: Prefer struct_size over open coded arithmetic
Date:   Sat, 25 Sep 2021 13:42:05 +0200
Message-Id: <20210925114205.11377-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Yb/8SLe1hPGKDCy+r65BkW/b2XavDwCthM5r9hAymGEg6Eu+aie
 jPVkV1i/8Y6ZmFNZLQkqcBxXbVpLcj/LYe2co6AXVVasKNNkAlV8ldtLZViASleG56l8LCI
 89Fz7/VPH19/yh6fkE1NDzthFHk5I1O8iPZE4nwlwqK9YHZ7yT9JnctzOBhygvtz1ggaVpV
 ymoL0jaaPUHtgT9PzWksQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5tAKL7LSGAs=:1wCDbTUk7QZJvHUHguclsK
 ACuTwHKdKWLk7LDNSR6EjSGYVkA6ob/yH3hrzcfGOoIOfWLKhjeP/bYoHchd3z6SlphAx2cZW
 q+i347/DnlnkE9CFJ4nvP4K1HtOBN8Nc0jMcsNlf/sJDR8Rij4V1mRUhPUQlBHphh2n9q5snQ
 kpXECmbDDC8JvHkJUiavkA/oxIc7nR0cDTVLgYiEyhE0SsfxS43pPo495g4WLrrPqSIUktokO
 FeVS+9djC9VT/7GzRKhSYXkylq//eKw2oxsrJAoMpZq1MpiYXRxD2GDeCoyxm6cN1wQTIXF4A
 bbr8mafOXyaXgrRmHOMVTYZzANizzlByx3RBAgVo+aOVH0m9C0mlbeRpUJ15QWzcqyKRwpYst
 ohjJL4DkUwpuFHfw7OO+1nEPRlqN0uOHfqSjbp74siDnnhWqGkiMr1eaz4S0prOBCZpPLv/vM
 4gREzbgJs60iCweaQyQYeF0nffGj/Atle8/QR/dmy/xJVZrpeqNPBynMA+SM37FfTC9tbqH8o
 jhpvGaQqAw0/0kInDEfDoRZvwa2ybVlwPDAXfgsxqgKlSqhcFy6ZoAULPw/hoNIVP2g1mvghB
 ehtyKH6I2jFiIek1lMvmuZrD9RUDM5iAV8nX69bDSyvLpINQmVYGBmavTz5rzFQhYLYEaU+Ht
 f6O/ACuLliqJiH4oHSaFkV55w/HFWufJfxxXdq5yI/Fa1x9zHWQStRoT9kjYqFDwmwDyz6W1E
 jDg2p658wbcG9Ng1L16FgmdBG2GPWlPYSi8ttZmqv++Yw3jFf6ZbrWv6jilFaS94ZNZ9GYFtS
 yWkBveataHXMHnLGnr1UMV5M/YviZp61KLEZfct0s6xN2oitBh541T3vhY2j/pcoqcknrsS2n
 VyVDh6KfHsuzy1Cwf+E2YXBso3TSl5rl0e0nQLjYuwBMm8XSNHzi57fk+OpEs28iS/1Zkavud
 i1er6cgTSMqQ137l16lt660+op55613Xq+Q09jCkIS4fiyXOyMaMWprFOZ5cYb4Mt0o6s8cP/
 o7P3UVtunpvz/Ymo/JAcIVMoDXfMwmQsh+4g+g8OK1psCB+7WL8tvvHb5Xu0WL95ITHaA4s1q
 H7dnSXB4KwGEjs=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kzalloc() function.

This code was detected with the help of Coccinelle and audited and fixed
manually.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
Changelog v1 -> v2
- Rebase against v5.15-rc2
- Remove the unnecessary "size" variable (Gustavo A. R. Silva).
- Update the commit changelog to inform that this code was detected
  using a Coccinelle script (Gustavo A. R. Silva).

 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ffb391967573..e341b3372482 100644
=2D-- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7477,8 +7477,8 @@ static int asc_build_req(struct asc_board *boardp, s=
truct scsi_cmnd *scp,
 			return ASC_ERROR;
 		}

-		asc_sg_head =3D kzalloc(sizeof(asc_scsi_q->sg_head) +
-			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
+		asc_sg_head =3D kzalloc(struct_size(asc_sg_head, sg_list, use_sg),
+				      GFP_ATOMIC);
 		if (!asc_sg_head) {
 			scsi_dma_unmap(scp);
 			set_host_byte(scp, DID_SOFT_ERROR);
=2D-
2.25.1

