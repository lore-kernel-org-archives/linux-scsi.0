From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
Date: Sun, 12 Jan 2014 14:23:34 +0200
Message-ID: <52D28946.3000202@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-14-git-send-email-nab@daterainc.com>	<52CE7ABA.9080403@mellanox.com> <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq11u0fr1gr.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Oren Duer <oren@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 1/10/2014 11:06 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> Sagi> I wander how we can skip sbc_dif_verify_xxxx if the transport
> Sagi> already offloaded DIF verify.  I think that the transport should
> Sagi> signal the core layer that it is able to offload DIF
> Sagi> (ADD/STRIP/PASS/VERIFY), in which case the core should turn off
> Sagi> the backstore DIF verify emulation to sustain performance.
>
> Yeah, for SAS and FC it would be nice to leverage DIX and let the ASIC
> do the actual checking and splitting. I assume the same is true for your
> hw.
>

Correct! we should avoid a duplicate DIF processing. if the HW supports 
offloading DIF processing, target core can shutdown backstore 
verfy_read/verify_write methods.
