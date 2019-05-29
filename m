From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v2] wd719x: pass GFP_ATOMIC instead of GFP_KERNEL
Date: Wed, 29 May 2019 14:13:18 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1905291412360.242480@chino.kir.corp.google.com>
References: <20190529175851.GA10760@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529175851.GA10760@hari-Inspiron-1545>
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 29 May 2019, Hariprasad Kelam wrote:

> dont acquire lock before calling wd719x_chip_init.
> 
> Issue identified by coccicheck
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> -----
> changes in v1: Replace GFP_KERNEL with GFP_ATOMIC.
> changes in v2: Call wd719x_chip_init  without lock as suggested
> 		in review

Why was host_lock taken here initially?  I assume it's to protect some 
race in init that leads to an undefined state.
