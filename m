Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC36306744;
	Sat, 29 Aug 2026 01:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787967235; cv=none; b=DXls49CSn3vOBoauDPGtqOlsK5Kh+N0cViQ6HUac718IevnhmGEv0+GeDNskVE7S36sR0DhKDdaTL2dSOEd1xKEEmLoJAIq1hvVXygVomOpTaOrgyVaOgsprUs7R/HJKghRpF+tuaMH19UcQaYorWPOxq/PM3Vku7ZU+7OZqQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787967235; c=relaxed/simple;
	bh=HxhvuIu14D5oWRmsJTxe/MS4jbBe0tc41awDFzEaEho=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=HyYaudphMdijDONMBeQ1JYFE8BaaebpgLH7kMGUxIGOeFcmY4oStHkivQJy7QofB9YPLdeMh9DV1G+v3AS6hS2q4nE2sx/5YWTHmSRVZq5RxN2f9oKbyvsTt11LqpG/sf54mi0YLjU6Hr+vPs1dqvglh1n57jHagO1c4fCYHH0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BC/btGKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BC/btGKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9773B1F000E9;
	Sat, 29 Aug 2026 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787967231;
	bh=qcLcaICBn/Ust3qCyT+QAX9s51VWpBQrTS4NDoDQpJQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=BC/btGKtX1ijynyzc9Inb7SM82UVg6ZQge8iQ45RQTu1QH5F12BEvBS9GlF8wNoWt
	 uW7FYVw2KrvE8fvQIfkzegJwdVpzC69wmYI7ruePsIoWEJddG97jMim5XIF/Vd5vT7
	 eedaDoZE7W4s7H/gsLoLV+SE+4KIKaM3WnPphjDoQyOdwzwsVcC6H5m7QRU80EKoH3
	 nJeYr2QJp6tH5rVnmvkpOrdeGFRF1JuFZpFWu0hixvkFR7uJgO56zB9VMTlMpBYeav
	 +zarnyNHD9Fn1ilVroE5P4N6t+UDjJSV2+KJHizOzaCSQMu3vOJkPrRePGLpOBIIkW
	 vzNAovJ6PDbmA==
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Cc: Linmao Li <lilinmao@kylinos.cn>,  "Satish Kharat (satishkh)"
 <satishkh@cisco.com>,  "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
  "Martin K . Petersen" <martin.petersen@oracle.com>,  "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,  Hannes Reinecke
 <hare@kernel.org>,  Justin Tee <justin.tee@broadcom.com>,  Naresh
 Gottumukkala <nareshgottumukkala83@gmail.com>,  Paul Ely
 <paul.ely@broadcom.com>,  "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>,  "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "Gian Carlo Boffa (gcboffa)"
 <gcboffa@cisco.com>,  "Arun Easi (aeasi)" <aeasi@cisco.com>,  "Arulprabhu
 Ponnusamy (arulponn)" <arulponn@cisco.com>
Subject: Re: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <SJ0PR11MB5896ACCB95853799B658E896C3A02@SJ0PR11MB5896.namprd11.prod.outlook.com>
	(Karan Tilak Kumar's message of "Mon, 24 Aug 2026 09:54:04 +0000")
Message-ID: <yq1o6elk8wy.fsf@mail.kernel.org>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
	<20260819114242.3598034-2-lilinmao@kylinos.cn>
	<SJ0PR11MB5896AC03937115745995EFDFC3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
	<SJ0PR11MB58963CA2B53ABA6D1E89A0B1C3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
	<SJ0PR11MB5896ACCB95853799B658E896C3A02@SJ0PR11MB5896.namprd11.prod.outlook.com>
Date: Fri, 28 Aug 2026 21:33:50 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Karan,

> Thanks for the change. It looks good.
>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
