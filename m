From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 7 Feb 2013 15:45:32 -0800
Message-ID: <20130207234532.GB4771@blackbox.djwong.org>
References: <20130206195122.GA30652@sgi.com>
 <20130206202444.GA4771@blackbox.djwong.org>
 <yq1obfwrleq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1obfwrleq.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 07, 2013 at 02:09:17PM -0500, Martin K. Petersen wrote:
> >>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:
> 
> Darrick> and more recently I've theorized that we could add a magic
> Darrick> fcntl/ioctl to make the kernel recognize, say, the first iovec
> Darrick> of a O_DIRECT *{read,write}v call as the PI buffer, which I
> Darrick> think is similar to how DIX gets PI data to a disk.  But it's
> Darrick> not like I have any code to show for it.
> 
> I don't particularly like the "stick it in the first iovec" magic. Also,
> we need a bit more than this. A handful of knobs need to be present to
> convey how the PI should be sliced and diced. So then we get into the
> territory where the first iovec is a PI descriptor of some sort. And
> then the second entry is the PI buffer.

Hm, well if we're adding another IO_CMD_ anyway, it probably isn't that hard to
find space to stuff in an extra pointer or two to a PI descriptor + buffer.

(or a pointer to a descriptor that itself points to a buffer...)

> Darrick> I /think/ it's fairly straightforward to change the directio
> Darrick> submit code to find the userspace PI buffer and amend the block
> Darrick> integrity code to attach our own PI buffer.  
> 
> I recommend that you check out how I do this in oracleasm.

Is there a newer one than this?
https://oss.oracle.com/projects/oracleasm/files/sources/

(Nov. 2008?)

> 
> Darrick> You'd still have to let the block layer set the sector # field,
> Darrick> but afaik that won't affect the crc or the app tag.
> 
> Correct. But the right way would be to pass the ref tag seed in as part
> of the IOCB and let sd or the HBA hardware do the remapping.

<nod>

--D
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
