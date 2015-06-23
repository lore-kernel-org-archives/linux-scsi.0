From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Tue, 23 Jun 2015 13:03:00 -0400
Message-ID: <yq1mvzq4at7.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
	<CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
	(Tom Yan's message of "Wed, 24 Jun 2015 00:41:20 +0800")
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Currently what the kernel does is assume all devices support 1
Tom> sector granularity.

The ATA Command Set does not allow for any other granularity than 1
sector.

Bigger granularity reporting is supported in SCSI SBC to allow for
thinly provisioned disk arrays with a bigger allocation unit. It is
common for disk arrays to provision LUN space in units of 1MB or more.

Tom> For my Intel SSD, which actually has a lower limit of 8 sectors, it
Tom> shows: Data Set Management TRIM supported (limit 1 block) while for
Tom> the SanDisk Extreme USB, which actually has a lower limit of 256
Tom> sectors, it shows: Data Set Management TRIM supported (limit 8
Tom> blocks)

It don't know what these "lower limits" you are talking about are.

What hdparm tells you is that DSM TRIM on the Intel drive supports 1
block (512 bytes) of range payload data. Whereas the SanDisk drive
supports a full 4KB page of range payload data (8 * 512 bytes).

We did try to enable payloads bigger than 512 bytes back in the day but
most drives that reported supporting the bigger payload actually didn't
and all hell broke loose. So we reverted to a single sector payload for
libata.

I still have the payload patch in my SSD test branch and regularly test
with it. But there are still drives that fail in mysterious ways with it
in place and so far I haven't felt compelled to maintain yet another
blacklist.

-- 
Martin K. Petersen	Oracle Linux Engineering
