From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Thu, 14 Apr 2016 17:59:48 +0200
Message-ID: <570FBE74.2040202@suse.com>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
 <20160413180735.GD3676@htj.duckdns.org> <570F2E33.3080709@suse.de>
 <20160414154338.GB12583@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160414154338.GB12583@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/14/2016 05:43 PM, Tejun Heo wrote:
> Hello, Hannes.
>
> On Thu, Apr 14, 2016 at 07:44:19AM +0200, Hannes Reinecke wrote:
>> Hehe. No, it isn't, if you look closely.
>> (Or make that: it _shouldn't_, and I've messed it up)
>> (That's what the 'fpdma' parameter is for)
>>
>> The benefit is not so much for normal operations, but it'll give us
>> a performance improvements on SMR drives where we need to issue
>> READ LOG DMA EXT rather frequently. There we really want to have
>> them as NCQ commands.
>
> I'm still a bit confused.  Isn't it part of EH?  If so, the path is
> never traveled with other commands in flight and thus whether a
> command is NCQ or not doesn't make any difference.  The only thing
> it'd do is making devices which advertise the capability but don't get
> it quite right fail.
>
For this patch, yes, you are right.
However, the ZAC enablement patches later on submit READ LOG EXT 
commands (for REPORT ZONES), and _they_ benefit from NCQ encapsulation.

Cheers,

Hannes

