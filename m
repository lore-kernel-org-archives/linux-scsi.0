Received: from bsmtp5.bon.at (bsmtp5.bon.at [195.3.86.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69D416DED2;
	Sat,  2 Nov 2024 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.86.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730550390; cv=none; b=H79C0M/iORRjrQSZMXXpbY+4iACeeSaUo4ENq1Gu0xM0T5Rc8shFp3Ix8ZnBhGALqtpVcmwFOSK3FzV5wiYGc1c+YcOKN3KQtTqXH9uHCK0ZsmXL/MFY74RR2lxWXiS3v7ux7lLMjfy67DGEvHrM/MfPR3zbaM2MB/5VmDOBNJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730550390; c=relaxed/simple;
	bh=dSDT0vEz62CqVIjmyfx/Kg7MuHDy6wHEDFL4wdosaDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c5sUOr4PStp5aoMQ7JfAfC4Owmegw5Vy1r5D4sL/VpRaQiKuMogndgfb6wudRt5R1sZYhcEHNU9igpUTCV8i39jV4GgsSwETyc9Bys77qeBddhre+EaQ0vC4ReHFzxanWkI8DrXVZZ/Pv+I7upFWl1J5NsUAEdMG/oB99r7iLPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grossegger.com; spf=pass smtp.mailfrom=grossegger.com; arc=none smtp.client-ip=195.3.86.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grossegger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grossegger.com
Received: from bsmtp.bon.at (unknown [192.168.181.102])
	by bsmtp5.bon.at (Postfix) with ESMTPS id 4XgcQz105Mz5tsn;
	Sat,  2 Nov 2024 13:26:19 +0100 (CET)
Received: from [192.168.0.62] (unknown [80.122.193.150])
	by bsmtp.bon.at (Postfix) with ESMTPSA id 4XgcQc0PLpzRnmR;
	Sat,  2 Nov 2024 13:25:58 +0100 (CET)
Message-ID: <ef82b344-dd7c-4b56-85d7-9f7dc361876f@grossegger.com>
Date: Sat, 2 Nov 2024 13:25:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/1] aacraid: Host adapter Adaptec 6405 constantly
 resets under high io load
To: Dirk Tilger <dirk@systemication.com>, Sagar.Biradar@microchip.com
Cc: james.hilliard1@gmail.com, martin.petersen@oracle.com,
 khorenko@virtuozzo.com, aacraid@microsemi.com, Don.Brace@microchip.com,
 Tom.White@microchip.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Gilbert.Wu@microchip.com
References: <106f384f-d9e2-905d-5ac5-fe4ffd962122@virtuozzo.com>
 <CADvTj4rd+Z8S8vwnsmn2a7BXDPBwx1iqWRmE+SbtWep=Lnr20g@mail.gmail.com>
 <BYAPR11MB36066925274C38555F20FB17FA339@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4qH5xuK9ecEPi3Pm9t962E=nnH0oTBqWv4UPmibeASqdQ@mail.gmail.com>
 <BYAPR11MB36065EE0321C0AE6A4A3ECC7FA049@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4oej_E3tHm6tzOAhA=n2WughvDfQsaxKbP5Sxb+CeZu=w@mail.gmail.com>
 <BYAPR11MB360625E5945D5D3B29571857FA099@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4oNCrwHBRu-rUZtnxoqVkvyxG_Cg07RTAuwpNsGfjWKcw@mail.gmail.com>
 <BYAPR11MB3606FB1E651EC9B51BD8A0B7FA1B9@BYAPR11MB3606.namprd11.prod.outlook.com>
 <BYAPR11MB3606E15393A4C11CCFAF9C53FAE69@BYAPR11MB3606.namprd11.prod.outlook.com>
 <ZyJKTug2AtqWs3BQ@mactool-usb>
From: =?UTF-8?Q?Christian_Gro=C3=9Fegger?= <christian@grossegger.com>
In-Reply-To: <ZyJKTug2AtqWs3BQ@mactool-usb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On October 30, 2024, at 16:01, Dirk Tilger wrote:
> I had set "msi" to "2" and the problem persisted. I have not tested
> msi=1 but as far as I understand it should have the same effect with
> regards to the system hangs.

Hi,

Yes, as far as I understand, setting msi is not enough, because when I 
look at the code the host->can_queue variable is set to the wrong value 
for the Series-6 Card since Commit 395e5df79a95 ("scsi: aacraid: Remove 
reference to Series-9").

Before the patch the driver uses the lower 16 bits of status[3] as the 
maximum number of outstanding FIBs allowed by the Series-6 controller. 
After the patch is uses the upper 16 bits of status[3]. (comminit.c:581)

Kind regards,
Christian
