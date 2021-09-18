Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE00C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 11:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F2861041
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 11:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbhIRLUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 07:20:20 -0400
Received: from mout.gmx.net ([212.227.17.21]:48133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230313AbhIRLUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Sep 2021 07:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631963904;
        bh=kSd6PjAeNeaTRnAPtJhlmElKGDj3xQowRv0TDrStuVI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Vvo5aPPriRaxkFFGLbemLtPKLzpWQB6FY+uoDECZGTYL5QhOszcymqrv7eQgiuIOn
         +pcYp0zCscDyNSjnU3yBV+feNchAPdrJWwJmfEtHBK2uR9CV7XYi96pTFbO2y41i8q
         AnIy0p2alJSKtljTFcqe94m85p3vzi9UZZV/Vl8g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MWRVb-1mPbFj0t6h-00XspB; Sat, 18 Sep 2021 13:18:24 +0200
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
Subject: [PATCH] scsi: advansys: Prefer struct_size over open coded arithmetic
Date:   Sat, 18 Sep 2021 13:18:05 +0200
Message-Id: <20210918111805.15471-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/oD9QjKU+EVW2qc7N/g++w8kBj0WN/GOhqBZGr9qi/Zr+BUlNVS
 MYRqpyTQECxjX7rg7HSQGKicD4GEq95vvqyJDZ0HHTIIitpuCjCYgxXkHFJkl7f/fyM8inX
 4YfPtcbf3F28x9LWoxfWqOnw+T/hmXjsdj1r8qDbfE3o6a+42RyEQcRC9NkwKHLBFxNi5Ga
 cwKMat6M8qMZEzBsyxwIQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:EiIkyuEQyHg=:281aC23z+/pedZ478ytxHH
 +PUAm2VgUuJN1JD3KvpHH757/v9AyDC3H5WMhLVGUkB5G6vUIE+1VSBcjhwfHlFJ3CbrU2t2g
 ZTcSk4iDS7LG36GmrDNb/QkACrP92y4fuxrpp6LsoR0rRleYrjk/ElR/kFCXghfsxG9m8lRfj
 43d/tlAFmI2QXFOo5hvQq2G3hoC/9j1ZHOxn45zUzvwgUumlDUiKOMPmxFJ4Gp0buhmSCLLJ0
 MeecWQv9kKuJMoIYyvmNsZ88rmvhRArtNRDby7QKrfP/A+gl2PNg9qqAVsP3GJf7AKyu+1Eea
 E4iTtS1Uv3ZTXifHu2SG85M2RRV90pqSuLJuDceObmMYakmEFE9Z5Jzn8i3r+ssKDrVTTVh3M
 J+kVPqcxfGqJMIvlvS/83Qo4X65D2aumYekY5cOgfw5aW4iNv4wBD/Mq4x9DVi00i5bGD5Zw6
 xZ79wkbs52imX8HGE7sAamxl6EqhgvWYOerZH3/YLDFOUm59saygqIBYfFKrhWerCX44Y7obI
 sADp5LtNvIIGQKoL4+hKUafswr3zfvNacpdDUcYGumVU8+1FlFwcxV5vo9wqc3dXyUtliQ296
 aZFP0DD8qCGTwCKSlyJbww+IMxYzSZzMaDw6zRos1oQtOAUVoERBZVzE3WhmKR9hDmG7ZsBSu
 p68X2ui9q6rzZdRxbcGHPgem6nRcR+cpnIkPYA0jtrFvcwN+PCLkiyDvH9IAxDqB6TwhC97LP
 BSulhEtR99Gu1cPz5kVzRkPrXTnaM+FkpCz7YPQpSwkoclQGdmYKGKJred/VJ9hDosFyBwOBQ
 2xuA5BvOniOlAJpRuUn6jc6yqLqqHJ6w7/PAIQLUSGY0nTdv5hdYdoMtJr+82X4+l9k7G3cEE
 fVIceAiW8G1MV9PVoAT7RZ9jsNZQoFbdOaamtTqmn8u9VIBeJlaeauEb+SxBN66ZQiId7999O
 2Q2IFGPXw0OHvrK0a7eRWhn7iahstpZO2uknqvzj8Zob4jgCZYa61YUyyWV9khyxSbiQo3jDy
 XBdFjW62j6/V83gs4UsJMMIc1I/o08aC985EMrJdtYXDc66t/XM7QW8rHdLLeSwd8uQmsz4Ek
 3NVuTlew12xAiw=
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

So, refactor the code a bit to use the struct_size() helper instead of
the argument "size + count * size" in the kzalloc() function.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 drivers/scsi/advansys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ffb391967573..fe882502e7bf 100644
=2D-- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7465,6 +7465,7 @@ static int asc_build_req(struct asc_board *boardp, s=
truct scsi_cmnd *scp,
 		return ASC_BUSY;
 	} else if (use_sg > 0) {
 		int sgcnt;
+		size_t size;
 		struct scatterlist *slp;
 		struct asc_sg_head *asc_sg_head;

@@ -7477,8 +7478,8 @@ static int asc_build_req(struct asc_board *boardp, s=
truct scsi_cmnd *scp,
 			return ASC_ERROR;
 		}

-		asc_sg_head =3D kzalloc(sizeof(asc_scsi_q->sg_head) +
-			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
+		size =3D struct_size(asc_scsi_q->sg_head, sg_list, use_sg);
+		asc_sg_head =3D kzalloc(size, GFP_ATOMIC);
 		if (!asc_sg_head) {
 			scsi_dma_unmap(scp);
 			set_host_byte(scp, DID_SOFT_ERROR);
=2D-
2.25.1

