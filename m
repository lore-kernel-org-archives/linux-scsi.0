From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/3] message: fusion: Fix line over 80 characters
Date: Sun, 03 Jun 2018 13:03:03 -0700
Message-ID: <1800e18130f7f768128feea2755f2c6ea0af7241.camel@perches.com>
References: <cover.1528031458.git.rvarsha016@gmail.com>
         <ae9327e821e82a9c9e6a41c1fa12ec02496189f2.1528031458.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ae9327e821e82a9c9e6a41c1fa12ec02496189f2.1528031458.git.rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2018-06-03 at 18:52 +0530, Varsha Rao wrote:
> Line over 80 characters is split to fix the following checkpatch issue:
> 
> WARNING: line over 80 characters
[]
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
[]
> @@ -5690,7 +5690,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
>  		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
>  			continue;
>  
> -		if (!(component_info = kmalloc(sizeof(*component_info), GFP_KERNEL)))
> +		if (!(component_info = kmalloc(sizeof(*component_info),
> +		      GFP_KERNEL)))
>  			continue;

It's much more common to split this into multiple statements like

		component_info = kmalloc(sizeof(*component_info), GFP_KERNEL);
		if (!component_info)
			continue;

but the continue in a loop with a known alloc failure
seems silly as the next alloc is also extremely likely
to fail as well.

btw: Are you actually using this code?

If not, perhaps it's better to send cleanup only patches
for files in drivers/staging as practice instead.
