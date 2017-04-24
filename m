From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH] lpfc: Fix panic on BFS configuration.
Date: Mon, 24 Apr 2017 09:16:00 -0700
Message-ID: <4b43a678-2e7e-5543-d0e8-d803f195238b@gmail.com>
References: <20170422002404.16027-1-jsmart2021@gmail.com>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170422002404.16027-1-jsmart2021@gmail.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, emilne@redhat.com, jthumshirn@suse.de, linux-block@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Please disregard this patch. there is an issue in the fix

-- james


On 4/21/2017 5:24 PM, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
>
> To select the appropriate shost template, the driver is issuing
> a mailbox command to retrieve the wwn. Turns out the sending of
> the command precedes the reset of the function.  On SLI-4 adapters,
> this is inconsequential as the mailbox command location is specified
> by dma via the BMBX register. However, on SLI-3 adapters, the
> location of the mailbox command submission area changes. When the
> function is first powered on or reset, the cmd is submitted via PCI
> bar memory. Later the driver changes the function config to use
> host memory and DMA. The request to start a mailbox command is the
> same, a simple doorbell write, regardless of submission area.
> So.. if there has not been a boot driver run against the adapter,
> the mailbox command works as defaults are ok. But, if the boot
> driver has configured the card and, and if no platform pci
> function/slot reset occurs as the os starts, the mailbox command
> will fail. The SLI-3 device will use the stale boot driver dma
> location. This can cause PCI eeh errors.
>
> Fix is to reset the sli-3 function before sending the
> mailbox command, thus synchronizing the function/driver on mailbox
> location.
>
> This issue was introduced by this patch:
> http://www.spinics.net/lists/linux-scsi/msg105908.html
> which is in the stable pools with commit id:
> 96418b5e2c8867da3279d877f5d1ffabfe460c3d
>
> This patch needs to be applied to the stable trees where ever the
> introducing patch exists.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Cc: stable@vger.kernel.org
