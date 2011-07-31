From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Sun, 31 Jul 2011 15:44:34 -0700
Message-ID: <1312152274.11635.8.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-08-01 at 00:28 +0200, Jesper Juhl wrote:
> We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
> We also do a lot of variable assignments that are completely pointless
> if the allocations fail.
> So, let's move the allocations before the assignments and also make
> sure that we free whatever was allocated to one if the allocation for
> another fails.

> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
[]
> +		new_param->name = kmalloc(strlen(param->name) + 1, GFP_KERNEL);
> +		new_param->value = kmalloc(strlen(param->value) + 1, GFP_KERNEL);
[]
>  		memcpy(new_param->name, param->name, strlen(param->name));
>  		new_param->name[strlen(param->name)] = '\0';
>  		memcpy(new_param->value, param->value, strlen(param->value));

kstrdup
