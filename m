From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Fri, 20 Sep 2013 23:32:29 +0900
Message-ID: <CAC5umyhFe-Kb2r-by39S=C9FZmRS+OBqKeE+=hcGvntAKGFyfg@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
	<yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	<CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
	<1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
	<CAC5umyhVNcwu2k7wEND5DvxRGE+_tyWBNpWjVdQ9DRTyV2qCaw@mail.gmail.com>
	<1379670782.5938.14.camel@x220.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379670782.5938.14.camel@x220.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, Douglas Gilbert <dgilbert@interlog.com>, Antonio Alecrim Jr <antonio.alecrim@gmail.com>
List-Id: linux-scsi@vger.kernel.org

2013/9/20 Paul Bolle <pebolle@tiscali.nl>:
> On Thu, 2013-08-22 at 23:49 +0900, Akinobu Mita wrote:
>> 2013/8/22 James Bottomley <jbottomley@parallels.com>:
>> > On Thu, 2013-08-22 at 21:42 +0900, Akinobu Mita wrote:
>> >> Unfortunately, this warning isn't fixed in linux-next, either.
>> >> Paul Bolle also sent a patch that fixes the same warning in a little
>> >> bit different way.
>> >
>> > Well, it is and it isn't.  Whether you see the warning seems to depend
>> > on how gcc was built.  My take is that an impossible default case just
>> > to keep some versions of gcc quiet is a bit pointless.
>>
>> As Joe said in the other reply, scsi_debug_guard could be a negative
>> value (scsi_debug_guard > 1 is only prohibited).  So this warning
>> does not seem a false positive.
>
> I too think that GCC is correct here. Perhaps the people not seeing this
> warning don't have CONFIG_SCSI_DEBUG set.
>
> A week ago Antonia also submitted a patch to silence this warning
> ( https://lkml.org/lkml/2013/9/13/649 ). That's at least the third time
> someone tried to silence it since it got introduced in the v3.11 cycle.
>
> Akinobu, could you please say how you'd like this warning to be
> silenced? Or is an actual fix queued somewhere?

Yesterday, I sent a patch set which includes two fixes for this issue.
I wish this to be merged and I'll do my best.

http://marc.info/?l=linux-scsi&m=137950732530325&w=2
http://marc.info/?l=linux-scsi&m=137950732530326&w=2

The first one prevents scsi_debug_guard from being a negative value by
changing the type of scsi_debug_guard to 'unsigned int'.

The second one is actually titled sparse warning fix, but it also silences
this GCC warning by chaning from switch statement to if/else statements.
