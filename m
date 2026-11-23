Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.81.86.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442770;
	b=vigzqJvkELXKDU/c/cueGPHXJa5Ok9M+iHNSAaH3gHeG2+Q3ahV4u3RZ0wxTydwgP+AC
	 OIegGeqlVfftC+M6hxFcmO1KF8QYd1eDM39a736YOQ3ShxDr4dS1RVjbiP/v6LAYxfOSz
	 E6SlQQYqX91hdeMY5BVeIVRaKuc4bwt7O8QDZW+Or6d7To2iDZz3NsDqAHc/sSWRNiuE5
	 f6Kw6CZstocgLSa36M0t70CXTzEg36oBhkAlxwiSKEVrXD4pbkQSd/3xXkfokj4abhnzs
	 2dwqRh5KDWjXQaKHb9xvecAA7MhcbsIw3Grp0GrriTaJs+iRjAOjaMKBoEYgGN9TJFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442770;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=EpX2g2geXyBWspkSTZO7Ivn2ya4oP/tf6r3a8tkLRdU=;
	b=E4QE9tfwCZuKayhpV/sts7LT6z5pKquLT5m8bJznDLaTbKob3EVm6CXat61spIZTji5H
	 sUatq01Kuom2XqqSEQPVQmx35/SokEhM6K7KIvp0qd94VtOBHqsTgzLcaI0ukzkgMmFkK
	 r7LR1F5R/wnpYuUxuv/ytqyVqUvwGdGGZbvpTSyMFAAncov330EHdwHoFe9ItfBMOr2gB
	 Hg/rsErPdFye9caVw7AwZ94IgzksOzqFKclClGr2G1AOiXqwxzU/t/T+B1rY5aEBSzwHA
	 YHGvwL8NkvaNo3P2V5m2pW39J3+s01p2h0cJG/0UvOGgOtSqxBICzfrInadTkkhwxNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nathanst.com;
	spf=pass smtp.mailfrom=nathanst.com;
	arc=none smtp.remote-ip=51.81.86.232
Received: from mx1.nathanst.com (pub1.nathanst.com [51.81.86.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD73C606A31E;
	Mon, 23 Nov 2026 14:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD73C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nathanst.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nathanst.com
Received: from mycroft.stratway.net (unknown [192.168.88.1])
	by mx1.nathanst.com (Postfix) with ESMTPS id 10340101468;
	Mon, 23 Nov 2026 09:06:03 -0500 (EST)
Received: from diagon-alley.stratway.net (diagon-alley.stratway.net [192.168.88.14])
	(authenticated bits=0)
	by mycroft.stratway.net (8.14.3/8.14.3/Debian-9.1ubuntu1) with ESMTP id 6ANE5wZo006586
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT);
	Mon, 23 Nov 2026 09:06:01 -0500
Date: Mon, 23 Nov 2026 09:05:58 -0500
From: Nathan Stratton Treadway <vgerlists2026@nathanst.com>
To: Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 ata_passthrough_disabled
Message-ID: <awRIRpJIxWPJcn5i@diagon-alley.stratway.net>
References: <20261121155253.4980-1-mat.jonczyk@o2.pl>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261121155253.4980-1-mat.jonczyk@o2.pl>

On Sat, Nov 21, 2026 at 04:52:52PM +0100, Mateusz Jończyk wrote:
> The uas driver blocks access to ATA passthrough commands for some
> devices it considers buggy. However, it does not expose any meaningful
> information whether the command was disabled by the driver or is
> genuinly not supported by the hardware. This creates a problem for the
> smartmontools program and makes it difficult for it to provide a useful
> error message.
>
> Link: https://www.smartmontools.org/wiki/SAT-with-UAS-Linux
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
[...]
> diff --git a/Documentation/ABI/testing/sysfs-class-scsi_device b/Documentation/ABI/testing/sysfs-class-scsi_device
> new file mode 100644
> index 000000000000..4dc8645bf59b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-scsi_device
> @@ -0,0 +1,10 @@
> +What:		/sys/class/scsi_device/*/device/ata_passthrough_disabled
> +Date:		Nov, 2026
> +KernelVersion:	v7.5
> +Contact:	usb-storage@lists.one-eyed-alien.net
> +Description:	(RO) Indicates whether the driver blocks access from userspace
> +		to ATA passthrough commands. Contains a value of '1' when such
> +		commands are denied as the hardware is considered buggy and they
> +		might interfere with a correct operation of the drive. Note that
> +		a value of '0' does not necessarily mean that ATA passthrough is
> +		available as it may not be supported by the hardware at all.

Would it make sense to explicitly mention something about "USB quirk flag
US_FL_NO_ATA_1X" in this documentation entry?

                                                        Nathan
