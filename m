From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
Date: Sun, 12 Jan 2014 11:37:22 -0500
Message-ID: <52D2C4C2.2040800@interlog.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com> <yq1mwj3r2py.fsf@sermon.lab.mkp.net> <52D286D9.5050500@dev.mellanox.co.il>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52D286D9.5050500@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 14-01-12 07:13 AM, Sagi Grimberg wrote:
> On 1/10/2014 10:39 PM, Martin K. Petersen wrote:
>>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
>> Sagi> What about FORMAT_UNIT emulation?  The backstore protection
>> Sagi> configuration is done at the target side via configfs/targetcli,
>>
>> I don't know of any non-disk devices that actually implement FORMAT
>> UNIT. Usually such configuration is done using the array management
>> interface.
>>
>
> Hmm,
>
> So this takes me to a corner I still don't understand, if a LUN is pre-formatted
> as T10-protected, what happens to unwritten blocks read?
> I mean, SCSI login executes some reads from sevel LBAs which will probably fail
> as blocks are unwritten.

Some observations: I haven't seen any disks pre-formatted
with T10-protection, they usually come pre-formatted without
T10-protection. Seeing it can take 10 hours plus to re-format
a big disk with T10-protection, it is not a bad idea though.

After formatting with T10-protection blocks seem to read as
zeros and the PI as all 0xff_s. [The blocks full of zeros may
have been the previous state.] Provisioning might come into
play, if so it makes sense for a FORMAT UNIT to leave all
blocks unmapped. In that case you should check the LBPRZ bit
and hope that it is set (found in READ CAPACITY(16) and the
Logical block provisioning VPD page). Also if provisioning
is in use, the GET LBA STATUS command will tell you if a
block is unmapped (although I don't have any disks that
support that command). So a tentative READ, for example
checking if a disk has a partition table, could be preceded
by a GET LBA STATUS command. IMO, if provisioning is enabled,
LBPRZ=0 then the GET LBA STATUS command should be mandatory.
Otherwise a tentative READ is a lucky dip.


Rob Elliott is trying to push the "feature set" idea used by
the ATA command set, into the SCSI command set. He doesn't
seem to have got much traction at T10 yet. Feature sets seem
to give vendors clearer guidance on what they should implement
to properly support new features. Much pain and bloat is
caused to the Linux SCSI subsystem (and other OSes) by vendors
who half implement new features.

Doug Gilbert
