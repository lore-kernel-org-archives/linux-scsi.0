From: Douglas Gilbert <dougg@torque.net>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 01:01:50 -0500
Message-ID: <45E277CE.3080405@torque.net>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45DF80C9.5080606@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

H. Peter Anvin wrote:
> Ric Wheeler wrote:
>>
>> We still have the following challenges:
>>
>>    (1) read-ahead often means that we will  retry every bad sector at
>> least twice from the file system level. The first time, the fs read
>> ahead request triggers a speculative read that includes the bad sector
>> (triggering the error handling mechanisms) right before the real
>> application triggers a read does the same thing.  Not sure what the
>> answer is here since read-ahead is obviously a huge win in the normal
>> case.
>>
> 
> Probably the only sane thing to do is to remember the bad sectors and
> avoid attempting reading them; that would mean marking "automatic"
> versus "explicitly requested" requests to determine whether or not to
> filter them against a list of discovered bad blocks.

Some disks are doing their own "read-ahead" in the form
of a background media scan. Scans are done on request or
periodically (e.g. once per day or once per week) and we
have tools that can fetch the scan results from a disk
(e.g. a list of unreadable sectors). What we don't have
is any way to feed such information to a file system
that may be impacted.

Doug Gilbert


