Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D974204F7A;
	Mon, 16 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348562; cv=none; b=YneuaUmuA5ahxfFVTvN0r5nd7Z1DyYGIi/toXueL+vadicQLgw5LNdqdF+c7CiuhUHt2rYgOVhIVdlxw4lXJ0yp3FRwxp2xLNj7mLTzd7n99t3ngfSIS1/h9LW5dMfZ7R9shCUgxzldOySTRpqG6XVOqAGYf7B7HFQA/tQmJQig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348562; c=relaxed/simple;
	bh=qDXql5e0dlsoUkgnrUATod+FIdN2oCDJzygWUo2bAxI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uhw48A+cVdogrpE+1yrw55WJn0Bi/fNb0h6dgMFgDEeKVAPNAHHg3Zvwyny8L24wWX5lgqAw5ESZrYUTf2ELmHZgtBhST8t4PQLwd2JoNq67SIx2lrWsTly8EH3l9uBtOmyRwJs16C3t6dQzQo6Z6PovxpyfK54IwOA5UF8G5C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=dZKEYZOu; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="dZKEYZOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=qDXql5e0dlsoUkgnrUATod+FIdN2oCDJzygWUo2bAxI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dZKEYZOuYIHlGMQvecOcn2uix+tggU/FkxIxa3rtLJR1ytNHcWcz1br92ylyAydSN
	 AaGg4z+b62l/Jnx9a7qEvnDagQ+5qgY9qf6W8AsuUNgYyCRQkCdx06aCL3kp1iUP93
	 j6hK6BCVF2OpA96b4jyQJflQWD6xbwe6Il2RcEQk=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:12 +0100
Subject: [PATCH 05/11] scsi: ibmvfc: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-5-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=1371;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=qDXql5e0dlsoUkgnrUATod+FIdN2oCDJzygWUo2bAxI=;
 b=dDgz9Ydf6v4c6BI1Dnxg8otiPshJZaMRuHcfAE+qvBaHTOKVPItUmjE76IBIT2jLd/2Q0crxB
 eOz7VAZ6/uECvTk+TKC/HJAY59i1sBjxrZyaCFMfdE1+rcuzjW44oZJ
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index e66c3ef74267a5527b21e6e1d13efb91425b158e..dc8401587bb529860d261ac83b924fceac8335d9 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3639,7 +3639,7 @@ static DEVICE_ATTR(nr_scsi_channels, S_IRUGO | S_IWUSR,
  *	number of bytes printed to buffer
  **/
 static ssize_t ibmvfc_read_trace(struct file *filp, struct kobject *kobj,
-				 struct bin_attribute *bin_attr,
+				 const struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = kobj_to_dev(kobj);
@@ -3662,13 +3662,13 @@ static ssize_t ibmvfc_read_trace(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute ibmvfc_trace_attr = {
+static const struct bin_attribute ibmvfc_trace_attr = {
 	.attr =	{
 		.name = "trace",
 		.mode = S_IRUGO,
 	},
 	.size = 0,
-	.read = ibmvfc_read_trace,
+	.read_new = ibmvfc_read_trace,
 };
 #endif
 

-- 
2.47.1

