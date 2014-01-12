From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 14:47:20 +0200
Message-ID: <52D28ED8.6020102@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>	<52D286D9.5050500@dev.mellanox.co.il> <yq17ga5pefv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq17ga5pefv.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 1/12/2014 2:33 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>>> I don't know of any non-disk devices that actually implement FORMAT
>>> UNIT. Usually such configuration is done using the array management
>>> interface.
> Sagi> So this takes me to a corner I still don't understand, if a LUN is
> Sagi> pre-formatted as T10-protected, what happens to unwritten blocks
> Sagi> read?  I mean, SCSI login executes some reads from sevel LBAs
> Sagi> which will probably fail as blocks are unwritten.
>
> Per SBC, PI must be initialized to 0xffffffffffffffff. Since an app tag
> value of 0xffff is an escape, this will prevent both target and
> initiator from performing PI-verification when that block is read.

OK, so this is an implicit escape (which will become explicit in 
DIX1.1?). So I will open that in DIF RDMA verbs.

> If a block is subsequently written and no PI is sent from the host
> (WRPROTECT=0), the target must generate valid PI for each block.
>
