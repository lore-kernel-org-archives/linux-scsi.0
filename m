From: Tejun Heo <tj@kernel.org>
Subject: Re: MD/RAID time out writing superblock
Date: Fri, 18 Sep 2009 00:47:44 +0900
Message-ID: <4AB25A20.3040103@kernel.org>
References: <20090916222842.GB16053@arachsys.com> <4AB17905.90606@kernel.org> <4AB23B17.2040204@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AB23B17.2040204@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Chris Webb <chris@arachsys.com>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Mark Lord wrote:
>> That's interesting.  One important side effect of issuing IDENTIFY is
>> that they will serialize command streams as they are not NCQ commands
>> and thus could change command patterns significantly.
> ..
> 
> SMART is the opcode that is most frequently implicated here, not IDENTIFY.

Yeap, any non-NCQ commands would do it.

> Note that even a barrier FLUSH CACHE is non NCQ and will serialize
> the stream.

Yeah, I was just thinking that issuing non-NCQ commands mixed with NCQ
commands would make the command stream fluctuate more.  Modern drives
are pretty good at lowering power consumption while idle so being more
fluctuative (is it a word?) might have something to do with the
problem.  Just a wild speculation tho.

Thanks.

-- 
tejun
