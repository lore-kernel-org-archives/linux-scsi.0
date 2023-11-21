Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C319CC1;
	Tue, 21 Nov 2023 01:57:06 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1r5NV7-0007lq-KD; Tue, 21 Nov 2023 10:57:01 +0100
Message-ID: <06eada44-166d-4ab4-acfd-f9cd65176460@leemhuis.info>
Date: Tue, 21 Nov 2023 10:57:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi regression that after months is still not addressed and now
 bothering 6.1.y users, too
Content-Language: en-US, de-DE
From: Thorsten Leemhuis <regressions@leemhuis.info>
To: Greg KH <gregkh@linuxfoundation.org>,
 Sagar Biradar <sagar.biradar@microchip.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Sasha Levin <sashal@kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Gilbert Wu <gilbert.wu@microchip.com>,
 John Garry <john.g.garry@oracle.com>
References: <c6ff53dc-a001-48ee-8559-b69be8e4db81@leemhuis.info>
In-Reply-To: <c6ff53dc-a001-48ee-8559-b69be8e4db81@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1700560627;bb90ccbb;
X-HE-SMSGID: 1r5NV7-0007lq-KD

On 21.11.23 10:50, Thorsten Leemhuis wrote:
> * @SCSI maintainers: could you please look into below please?
> 
> * @Stable team: you might want to take a look as well and consider a
> revert in 6.1.y (yes, I know, those are normally avoided, but here it
> might make sense).
> 
> TLDR: I noticed a regression (Adaptec 71605z with aacraid sometimes
> hangs for a while) that was reported months ago already but is still not
> fixed. Not only that, it apparently more and more users run into this
> recently, as the culprit was recently integrated into 6.1.y; I wonder if
> it would be best to revert it there, unless a fix for mainline comes
> into reach soon.
>
> Details:
> 
> Quite a few machines with Adaptec controllers seems to hang for a few
> tens of seconds to a few minutes before things start to work normally
> again for a while:
> https://bugzilla.kernel.org/show_bug.cgi?id=217599

Quick follow up, only saw this now while posting something to the
ticket: according to one reporter the problem even causes data damage.
To quote:

'''
if you run fsck.ext4 on ext4 file system with buggy kernel it will
damage file system and its data

using buggy kernel BTRFS scrub also says that checksums are wrong
'''

Ciao, Thorsten

> That problem is apparently caused by 9dc704dcc09eae ("scsi: aacraid:
> Reply queue mapping to CPUs based on IRQ affinity") [v6.4-rc7]. That
> commit despite a warning of mine to Sasha recently made it into 6.1.53
> -- and that way apparently recently reached more users recently, as
> quite a few joined that ticket.
> 
> The culprit is authored by Sagar Biradar who unless I missed something
> never replied even once to the ticket or earlier mails about it. Lore
> has no messages from him since early June.
> 
> Hannes Reinecke at least tried to fix it a few weeks ago (many thx), but
> that didn't work out (see the ticket for details). Since then things
> look stalled again, which is, ehh, unfortunate when it comes to
> regressions.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
