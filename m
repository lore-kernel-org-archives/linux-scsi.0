Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577812AD3D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195118; cv=none; b=nm90+okDsKE5mH3YMU0GYBvH27ofYmPf2AX/UqAxVhZ4Fvvv4AbdPL2f1CpF/73GpBZ/h4VjXxzb2SvBFz3O7VWIxa1kTb3QgwKcaDMVQM4iZN2GmzPE2mrmig0KoAkqT6fP5u74nH7nD3UOusqM9g44/AKmtTf7sHChtqI4CA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195118; c=relaxed/simple;
	bh=vJx339Ptvd6Q5seAb2UMkuQR2g1wHB5bKZGiaTR8zJU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Cxp8b0q8JYKWdzH/1I5204zHwZCXCAnqKfZTY2i+3orme6Hb2K4JicPIm1wfkWGctYSg88mEajjn+fIYxeqz2upknSqpTVt+m90qNHP5EwCru9TJc34304CcIP7IQJ8Y74H/v1HpV+7zDJ1MROcHreHWkD0msFvNNfjnZih/GTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=cyuPjdTf; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="cyuPjdTf"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id B8118240104
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 20:05:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1769195107; bh=3PwA9Be/c+sx6J+yRmqghf0UKZNH9XiqJmvIn3+haiw=;
	h=From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:To:Cc:Autocrypt:OpenPGP:From;
	b=cyuPjdTfSUK2citue4Pa2YeNMaIEsxhdRC481ac371gMEZ5Q/K+3AhaQzf7573wUr
	 29hsVDCVptXRdNY7VrD7+jQAJ7/Y2E2wWEJzhwK9pDajOlxSH9L1UpW1hy7gVxArrz
	 YALc/DV4QpX9GC+7F8WkTV4ykbEdwKKvAnWsBMlc0+eyr4/DMCx5FFIP+b9efqkVoU
	 mbPF1gH4NwYJ3KtvOnXEpNMZ0SSxDsg1nJ9InawXpKrUIOSiY5EtgoMI+A1k8isucd
	 1HheVBKmflm+iMtcQA0H3R5xDtmtzqLT7Iiq0kTIpXgYT//UuDD9FWJ9Oy9MlOewO1
	 fVgeTjoKYoz/g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4dyS6n1qTFz9rxD;
	Fri, 23 Jan 2026 20:05:05 +0100 (CET)
From: Markus Probst <markus.probst@posteo.de>
Date: Fri, 23 Jan 2026 19:05:06 +0000
Subject: [PATCH RFC 2/4] leds: dt-bindings: add disk trigger for each ata
 port
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-ledtrig_disk_-v1-2-07004756467b@posteo.de>
References: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
In-Reply-To: <20260123-ledtrig_disk_-v1-0-07004756467b@posteo.de>
To: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Jacek Anaszewski <jacek.anaszewski@gmail.com>, 
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-leds@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
 Markus Probst <markus.probst@posteo.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1066;
 i=markus.probst@posteo.de; h=from:subject:message-id;
 bh=vJx339Ptvd6Q5seAb2UMkuQR2g1wHB5bKZGiaTR8zJU=;
 b=owEBiQJ2/ZANAwAIATR2H/jnrUPSAcsmYgBpc8ZWtlbOWbS5hsTqlnvVj2v7vNUp7PZ2LZjiO
 +ABaSuq9WiJAk8EAAEIADkWIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaXPGVhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQNHYf+OetQ9LzQw/8DfqEIKdxy51MSLnBaF8SLYMeYmvrLhW
 7nTwXHjGZ3BT9Z3rWQOl3GCgLCOtUvtqnMTqb2Q7EzGOoiG4vDOU/PeR5wnsAzxXAJPF0459w8n
 nnO/89iO3rOc8ENWpHjqp0A0VguB7uAEZUYhdvu3ZVjWLak7oRHUgET1wtwhody0MqjpYr8kHQA
 qqIU5itLDZOPpmQtLV4QFNXOj/YQATTKbO8mIlKuVgM5xXC/NFlWPzdf8W/NzvkMggYA+jqLfIi
 KGJfeKljMgQtaMYiVjbgpylit6bWdiJixKjLvrse6Cp457e5kgTWmnNYSV0ZYKI262ZVblBQhMJ
 /yW9/4239A0uVHPrsVJsQ0UObvQ8qIr+7l2Rro0h2GC9mksn248DJvVHMrOhTWunWFlPjTsnFtg
 NCvvu4eef7stz87GeKQhuSzd3pbuj0eMVcA9Bpc2T88YZU8t1UOd+nOnsnWXb8/Yvz3S8VDFwr4
 ue8+IPHJMlUqQBw6oXHISIf/BJ8xduvDkUSTIo/R2jX85NSk6xkBhdShFoF1eOSm8p1bgoogyRW
 Br4UpR+ka5WL+3o/aNczR6AD6OjGvyQ8TkMDM5ccl+nqbw9friYqMvDt9ku5/kOOa9uyntVF0z+
 CoIxaZXzE1ErPS9kkFJVXtr4/0rqBRS4nXP4gd0vcaXePB4Ir3Pk=
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp;
 fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

Document disk trigger showing only disk activity for one specific ata
port.

Signed-off-by: Markus Probst <markus.probst@posteo.de>
---
 Documentation/devicetree/bindings/leds/common.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index d0f2fee7622c..ca51eeadfad0 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -136,6 +136,12 @@ properties:
       - pattern: "^mmc[0-9]+$"
         # LED is triggered by WLAN activity
       - pattern: "^phy[0-9]+tx$"
+        # LED indicates disk activity for a specific ata port
+      - pattern: "^.*-ata[0-9]+-disk-activity$"
+        # LED indicates disk read activity for a specific ata port
+      - pattern: "^.*-ata[0-9]+-disk-read$"
+        # LED indicates disk write activity for a specific ata port
+      - pattern: "^.*-ata[0-9]+-disk-write$"
 
   led-pattern:
     description: |

-- 
2.52.0

