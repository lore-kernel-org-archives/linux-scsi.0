Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400182;
	b=Pvr8oCNVGshq6zxCIzOqjFcOEqyD4Zu8muFL9I6SNSR+E4JWaXguG5ka92D+aC+d6jJN
	 TkgWlhoS3gdGDdTw8IPI60YEJ5ZNFb6Np1+0XFUmEH6oMZVpFfWs4iThxZiGuZ3x2s5rg
	 2jhU2B1CXdMTGsS5g26H1ENaORsvfeS+s3sd7X2FSz71hleuJ9bn7p19O9MDyGpoHRjmH
	 n3rzVqmYY7KwntlVOZQHC91CNq/s/aSoSHiT+XE46BIMs9CZXU1s8Mn80p3LxXsL4/+2M
	 x9DUFT5zcDAQqCeTVtptp1hyJf9qH0pNKpLPQTYy72CNNqVJcwrNzH8K+h0Vp3C8t3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=vEXFwAcU3h2jvYfLRqHw3kpH8xKWcO0W5sJb9FtmOUo=;
	b=5gPwXzOSRPFAu5g5DfaOcQAD2s71cczWC6g3wITz+DK+izDIFF8ALOEjpk+bYP4AKx4d
	 6ys93uaC0hBz02AzMj9sX845cBt51WivcAZtBSdRGFhQh9PhgKrLKSC7EFVpESP+gmu9e
	 N1hZa6YkFvy8htxMzGlzzkbAoTqN/5LexavPWt5pbtdAO4+ilHtnP1QmmbrbYJSbn1+JV
	 zqh/S6CwACw2uLnlEUDLnrdqmfZ15zSlNZsIc1XSoapUakU+1LIJzBRj7gSrwx0g/dfzS
	 n2AIcy2NW+tViGgaP/EtktyUykQxJnqbrakJ3mUQodepQ/1yo5CTLid8kswrv5pNG9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=xDlF5qn8;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3095606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:43:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3095606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=xDlF5qn8
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbj13X3bzlfvqQ;
	Fri, 30 Oct 2026 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1793400178; x=1795992179; bh=vEXFw
	AcU3h2jvYfLRqHw3kpH8xKWcO0W5sJb9FtmOUo=; b=xDlF5qn8PZxg54w3MvYn8
	P6kMfaXkRD4qRopgezhhtHca94wTK+PGbZpzGjNP7kmD87d5j9LHYhIudvaTobu6
	mZVKXh83Dv9y1dwqX1wtd0I/gn3K5V/S3s5vLxQbY7O4Nh8Vko1IsqMlTO8y7Tdt
	BGoPe4ebrOI5C3SAFZcXZ1zKec85BJoySMvZ0LqvnlTr9ffeK7evqLteMg5L+E07
	intNj8+kkySsDNHxMi/gCYBnWL4+okr0oTLZYprrULRwXDLmRZ5ke21Og92QHO3w
	+fzorLxdx9rpK2VsvD6+iXW0moejFrVE1LFYImigaECSMqibddvbpcSP68L9dtSP
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AJ66mb5UKwRZ; Fri, 30 Oct 2026 22:42:58 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbhx6X8RzlfvqD;
	Fri, 30 Oct 2026 22:42:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH 5/5] scsi: core: Limit retries of commands that receive UNIT ATTENTION
Date: Fri, 30 Oct 2026 15:42:39 -0700
Message-ID: <959f1c7628af83cd184ac51f35e38d654b261069.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fail non-removable commands in scsi_io_completion_action() on UNIT
ATTENTION if retries exceed max(cmd->allowed, 3). This bounds the
number of retries of commands for which scsi_decide_disposition()
exhausted the retries or that have been finished by the error handler,
e.g. because a target keeps reporting UNIT ATTENTION after recovery.
Since scmd->retries is not incremented for failfast commands on this
code path, failfast commands are retried until the command runtime
limit is exceeded, as before.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ccbc1d4193e0..b52b4c5daa42 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -849,6 +849,9 @@ static void scsi_io_completion_action(struct scsi_cmn=
d *cmd, int result)
 				 */
 				cmd->device->changed =3D 1;
 				action =3D ACTION_FAIL;
+			} else if (cmd->allowed !=3D SCSI_CMD_RETRIES_NO_LIMIT &&
+				   cmd->retries > max(cmd->allowed, 3)) {
+				action =3D ACTION_FAIL;
 			} else {
 				/* Must have been a power glitch, or a
 				 * bus reset.  Could not have been a
