From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 07:33:40 -0500
Message-ID: <yq17ga5pefv.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
	<52D286D9.5050500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52D286D9.5050500@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 12 Jan 2014 14:13:13 +0200")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

>> I don't know of any non-disk devices that actually implement FORMAT
>> UNIT. Usually such configuration is done using the array management
>> interface.

Sagi> So this takes me to a corner I still don't understand, if a LUN is
Sagi> pre-formatted as T10-protected, what happens to unwritten blocks
Sagi> read?  I mean, SCSI login executes some reads from sevel LBAs
Sagi> which will probably fail as blocks are unwritten.

Per SBC, PI must be initialized to 0xffffffffffffffff. Since an app tag
value of 0xffff is an escape, this will prevent both target and
initiator from performing PI-verification when that block is read.

If a block is subsequently written and no PI is sent from the host
(WRPROTECT=0), the target must generate valid PI for each block.

-- 
Martin K. Petersen	Oracle Linux Engineering
