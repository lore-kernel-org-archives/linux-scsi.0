From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 14:09:17 -0500
Message-ID: <yq1obfwrleq.fsf@sermon.lab.mkp.net>
References: <20130206195122.GA30652@sgi.com>
	<20130206202444.GA4771@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130206202444.GA4771@blackbox.djwong.org> (Darrick J. Wong's
	message of "Wed, 6 Feb 2013 12:24:44 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> and more recently I've theorized that we could add a magic
Darrick> fcntl/ioctl to make the kernel recognize, say, the first iovec
Darrick> of a O_DIRECT *{read,write}v call as the PI buffer, which I
Darrick> think is similar to how DIX gets PI data to a disk.  But it's
Darrick> not like I have any code to show for it.

I don't particularly like the "stick it in the first iovec" magic. Also,
we need a bit more than this. A handful of knobs need to be present to
convey how the PI should be sliced and diced. So then we get into the
territory where the first iovec is a PI descriptor of some sort. And
then the second entry is the PI buffer.


Darrick> I /think/ it's fairly straightforward to change the directio
Darrick> submit code to find the userspace PI buffer and amend the block
Darrick> integrity code to attach our own PI buffer.  

I recommend that you check out how I do this in oracleasm.


Darrick> You'd still have to let the block layer set the sector # field,
Darrick> but afaik that won't affect the crc or the app tag.

Correct. But the right way would be to pass the ref tag seed in as part
of the IOCB and let sd or the HBA hardware do the remapping.

-- 
Martin K. Petersen	Oracle Linux Engineering
