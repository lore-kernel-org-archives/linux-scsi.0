Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF3035E1A4;
	Mon,  3 Aug 2026 09:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750864; cv=none; b=gPIg6KaYMHIATpv3/mFJz3BnG4f1gEH/8KFddM1dXIcERcqiXON2TzUhWBwT+h1JO7DYJMzbgykXGRetVLABLKbkO9ota3qTK+7BGKwYUaQroamUJYE5bR0qvM6lETaIA/kH1NGCXYCs0w5rIaIoa+xL3rdFdICk/3OFdi7xc+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750864; c=relaxed/simple;
	bh=coWnFrdWDjH8Z3c76M7MSFy62PKcrltWv82fndpKiwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eT7/9u0JIDPL38f07qYEcOVEz3gPjDl8ogQOaQykyRJnnNdelXgxtqzKqXdv1ALx1EiFUUgjKDyS3+gLhNpSBzWD6lMZtYusqld/VV1fYa8TGJp8Xbkagvv+JAsAT27ATWWye/QAMWmxuSQAdFj2ZMQqKFEpH0Pmmoe/1qd7XOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dT1E9c3Y; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dT1E9c3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785750827;
	bh=GZ03EPD2RMxylnn/CLUGqP3Rrch6Nxym4GqmJgtyISM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=dT1E9c3YHR+flT1/5LtG1ts6ZpnMKGFfFL3i7mlJFRqHbj/3dxC0s8z69KoMfcYr/
	 nkfOiyA5p6SXNLawsoQ/wbhIe1aMdARjVFu+mf6ECeLFaAlopxR2QcOCdGLgz82eeA
	 mt7gaBypFrEKPIoXMV7lO2Y97xNga0wag+GzQN1I=
X-QQ-mid: esmtpsz17t1785750811t09786653
X-QQ-Originating-IP: 5HavgVDtO0+rs5FAeoIMkgzfENetjggfcZuX6GK066I=
Received: from PEN202512010004 ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 03 Aug 2026 17:53:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3872845753252988733
EX-QQ-RecipientCnt: 6
From: raoxu <raoxu@uniontech.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	raoxu@uniontech.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: negate wrapped memcmp() result
Date: Mon,  3 Aug 2026 17:53:28 +0800
Message-ID: <E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: N7k3iE00JiuZHsnbAtOTggDZHr/qEd6L+PbsROeznRKaF9haUZqEiI33
	Rxz3hJ7hr3OmdUzQlOe0J79nAzLA3JaHFjmXvVwTiAN7Fj2jAxrdYYnwwdE6ya9lkwrzYiJ
	6ZknnlLoQz7RcVMWlUmLi6noOhZwa0eIWWV63WfhYz3xGuBNeIZc6J2FHBSIF160DnyE1Ep
	vXZqWDcvnEb08Et/R0AmTQVsfOYij6IitpddOy8qgbwY0WC9mx4FYLNbNz0gyLn8ATzO/Ai
	kKs5IS+Vh6eX2TykNGxVdsMKMRPYzpRkSxfzNfvEmHVm0oPBeb52FqvMpml8H0Fpl10Z5rO
	p8CahUf66G9hdNwktKced+nD4SHxOFVr1rwIq8A9AHmCxUWsMOt1L9SbTWqKRj1/FFMNMEC
	Rt+xHQxis4rlXLMgUMPUKVFcOTsI6j4wc6FNoQllJh7WBsah5dyumktT3faX4d7WS8YA2dg
	6x9+poQk+fi76b79EWq8e971W2977JHLLw1cq/9FEdJcsgadCfoFGIIs27/mxGpfLaON9Ad
	ZUDxBirfHgLHy8v30OZKiX54Wk30rrwcyYfjisJI8ETSep7eoX4GJy6JI7pIk4ANCEqcTKh
	9XAxRAUStMrRD73LqlTLINMgDXqsnXPyyBhdeNCCzJHJwtJ+GMxgw0Pj+igP1Rdus3QHPjb
	5IKRWmti/K2JfwpkmcVpQaTM+2mKN5D5G0XB9etWRdRy46fkwzPWDGci0kQrz+cz4hgmlzR
	KUmeRjPLSGHnNSvJjMHv75xgPHOKL5OX5M4iro46h32MrzBjTA/t6X3YPHF2VAIpDczwjwU
	uEIBCJ1Ounuhp6NRO8zl8v5CAGbg0VoWppZUi7P2BafrJaHAzG3pFec4GHReEtZLE2iIuFK
	JpwM2DcUaQ3a2Vwqfm5j5PVVps2XhKa3+SL7H4gYV6gcmFrVZcKeCSSJtEH/V+M/D8lEv8i
	unCSa7B0I26/fGT4JNrRIz5Sy/dlgaqkpb3YpIYWHOKxsYSGRKT9BbANlroLl27Mok2s5Vs
	EWNck2urL4OFiGajjcOeZAA2W73soyY+oqfLgk4mtAPtaS8lS6
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

From: Xu Rao <raoxu@uniontech.com>

comp_write_worker() returns true when the compared data matches.
memcmp() returns zero for equal data and non-zero for different data, so
its result must be negated before it is stored in a bool.

The first segment already uses !memcmp(), but the wrapped segment uses
memcmp() directly, reversing the match result. Use !memcmp() there as
well.

Fixes: 38d5c8336e60 ("scsi_debug: add Report supported opcodes+tmfs; Compare and write")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9d1c9c41d0f9..a5911482fc44 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4310,8 +4310,8 @@ static bool comp_write_worker(struct sdeb_store_info *sip, u64 lba, u32 num,
 	if (!res)
 		return res;
 	if (rest)
-		res = memcmp(fsp, arr + ((num - rest) * lb_size),
-			     rest * lb_size);
+		res = !memcmp(fsp, arr + ((num - rest) * lb_size),
+			      rest * lb_size);
 	if (!res)
 		return res;
 	if (compare_only)
--
2.50.1

