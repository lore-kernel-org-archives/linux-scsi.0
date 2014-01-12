From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 12:21:51 -0500
Message-ID: <yq1ppnxnmj4.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net>
	<52D286D9.5050500@dev.mellanox.co.il> <52D2C4C2.2040800@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52D2C4C2.2040800@interlog.com> (Douglas Gilbert's message of
	"Sun, 12 Jan 2014 11:37:22 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

>> So this takes me to a corner I still don't understand, if a LUN is
>> pre-formatted as T10-protected, what happens to unwritten blocks
>> read?  I mean, SCSI login executes some reads from sevel LBAs which
>> will probably fail as blocks are unwritten.

Doug> Some observations: I haven't seen any disks pre-formatted with
Doug> T10-protection, they usually come pre-formatted without
Doug> T10-protection. 

Depends where you buy them. All the drives we ship arrive formatted with
T10 PI from the manufacturer.

However, nobody expects you to format a LUN on an array. When you create
a LUN on a PI-capable storage array, T10 PI is a storage management
interface option just like size, RAID level, etc. Upon creation, arrays
zero out newly provisioned LUN blocks and write parity, etc. If PI is
enabled on a LUN, blocks are written with all zeroes in the data block
and all ones in the trailing PI tuple. This is all part of the regular
LUN setup procedure.

In any case. The usage model is that you never format a disk unless you
are a tinkerer and bought a retail SAS drive at Fry's. Drives will be
delivered by your server vendor formatted with PI and ready to go.

If you use a non-disk storage device, whether or not to enable PI is
part of the LUN provisioning procedure (array management console, RAID
or flash controller card config utility, etc.)

Doug> So a tentative READ, for example checking if a disk has a
Doug> partition table, could be preceded by a GET LBA STATUS
Doug> command. IMO, if provisioning is enabled, LBPRZ=0 then the GET LBA
Doug> STATUS command should be mandatory.  Otherwise a tentative READ is
Doug> a lucky dip.

It's perfectly valid to do a legacy/unprotected READ from a T10 PI
device. Doesn't matter whether the blocks are unwritten or not.

-- 
Martin K. Petersen	Oracle Linux Engineering
