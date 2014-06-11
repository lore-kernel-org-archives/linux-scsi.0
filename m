From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Wed, 11 Jun 2014 10:24:36 +0300
Message-ID: <53980434.1000306@dev.mellanox.co.il>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com> <1402223228-23768-4-git-send-email-sagig@mellanox.com> <1402387450.5774.56.camel@haakon3.risingtidesystems.com> <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "roland@kernel.org" <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 6/11/2014 12:17 AM, Quinn Tran wrote:

<SNIP>

> QT> Instead of using existing value within cmd->data_length, can we
> calculated data_length based on secstors & blocksize.
>
> cmd->data_length = sectors * dev->dev_attrib.block_size;

We can do that I suppose...
Although it seems weird that the core discards the transport byte-count...
Just wandering if we should recalc on the DIF case only or always.

>
>  From the QLogic perfective, the cmd->data_length is pull directly from the
> wire (i.e. FCP header) when cmd is received.  In essence, it's whatever
> the Initiator is set it to.  We does not have any indicator to spot DIF vs
> none-DIF cmd when 1st received, unless the code do a peek.

Same for all transports I assume...

>
> With that said, the cmd->data_length does not guarantee to contain both
> "data length" & "protection length" when cmd is submit to
> TCM/target_submit_cmd().  In Dif-Insert mode, data_length will only
> contain the actual data(no Dif).

No, in the DOUT_INSERT/DIN_STRIP case, protect bits are off and the core 
will take the data length as is.
This case is covered.

> It's best that the SBC code re-calculate the actual data length and dif
> data length based on the number of sectors derived from the cmd.

Nic, what's your take on this?

Sagi.
