From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/2] target: 64-bit LUN support
Date: Wed, 10 Jun 2015 09:45:17 -0700
Message-ID: <5578699D.6090405@redhat.com>
References: <1433918483-46849-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1433918483-46849-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 06/09/2015 11:41 PM, Hannes Reinecke wrote:
> Hi Nic,
>
> here's now the patchset for making LIO-target support 64-bit LUNs.
> Pretty straightforward, plus an additional patch to remove the
> now obsolete limitation on 256 LUNs per TPG. There had been a
> comment in the header that REPORT LUN emulation would only support
> up to one page in payload, but I couldn't find any evidence for
> this in the code.
>
> As usual, comments and reviews are welcome.

Hi Hannes,

I think we also need to take care of how we report LUNs in spc.c 
spc_emulate_report_luns(). From reading SAM-5 4.7.7 (addressing methods) 
it looks like we're currently using the simple addressing format 
(address method = 0) and if we want to report more than 14 bits we would 
need to report the luns with a different addressing format.

I'm wondering if this could be seen as a bug in int_to_scsilun, but in 
any case I hope you'll take a look and make sure we're ok?

Thanks -- Regards -- Andy
