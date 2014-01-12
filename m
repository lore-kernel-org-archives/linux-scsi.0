From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 14:13:13 +0200
Message-ID: <52D286D9.5050500@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/10/2014 10:39 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> Sagi> What about FORMAT_UNIT emulation?  The backstore protection
> Sagi> configuration is done at the target side via configfs/targetcli,
>
> I don't know of any non-disk devices that actually implement FORMAT
> UNIT. Usually such configuration is done using the array management
> interface.
>

Hmm,

So this takes me to a corner I still don't understand, if a LUN is 
pre-formatted as T10-protected, what happens to unwritten blocks read?
I mean, SCSI login executes some reads from sevel LBAs which will 
probably fail as blocks are unwritten.

What is the usage model? perform Initiator login and then format the LUN 
on the target node? This is why I thought FORMAT_UNIT should be implemented.
I understand this corner will disappear in DIF v2 (following DIX1.1 
draft) with ESCAPE flags.
