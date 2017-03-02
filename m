From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: qedi: fix build error without DEBUG_FS
Date: Thu, 2 Mar 2017 15:51:02 +0100
Message-ID: <66f0d9ac-832e-f251-bff7-1cc1c2a5f826@suse.de>
References: <20170302121138.2361420-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170302121138.2361420-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Saurav Kashyap <saurav.kashyap@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, Chad Dupuis <chad.dupuis@cavium.com>, Manish Rangankar <manish.rangankar@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Arun Easi <arun.easi@cavium.com>, Hannes Reinecke <hare@suse.de>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/02/2017 01:10 PM, Arnd Bergmann wrote:
> Without CONFIG_DEBUG_FS, we run into a link error:
> 
> drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_poll':
> qedi_iscsi.c:(.text.qedi_ep_poll+0x134): undefined reference to `do_not_recover'
> drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_disconnect':
> qedi_iscsi.c:(.text.qedi_ep_disconnect+0x36c): undefined reference to `do_not_recover'
> drivers/scsi/qedi/qedi_iscsi.o: In function `qedi_ep_connect':
> qedi_iscsi.c:(.text.qedi_ep_connect+0x350): undefined reference to `do_not_recover'
> drivers/scsi/qedi/qedi_fw.o: In function `qedi_tmf_work':
> qedi_fw.c:(.text.qedi_tmf_work+0x3b4): undefined reference to `do_not_recover'
> 
> This defines the symbol as a constant in this case, as there is no way to
> set it to anything other than zero without DEBUG_FS. In addition, I'm renaming
> it to qedi_do_not_recover in order to put it into a driver specific namespace,
> as "do_not_recover" is a really bad name for a kernel-wide global identifier
> when it is used only in one driver.
> 
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
