From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: ibmvscsi: Don't use rc uninitialized in
 ibmvscsi_do_work
Date: Mon, 3 Jun 2019 16:25:13 -0700
Message-ID: <6fa1dd2e-676f-b12a-5bb6-e86f5c5628fa@linux.vnet.ibm.com>
References: <20190531185306.41290-1-natechancellor@gmail.com>
 <20190603221941.65432-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190603221941.65432-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

On 06/03/2019 03:19 PM, Nathan Chancellor wrote:
> clang warns:
> 
> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>         case IBMVSCSI_HOST_ACTION_NONE:
>              ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvscsi.c:2151:6: note: uninitialized use occurs
> here
>         if (rc) {
>             ^~
> 
> Initialize rc to zero in the case statements that clang mentions so that
> the atomic_set and dev_err statement don't trigger for them.
> 
> Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
> Link: https://github.com/ClangBuiltLinux/linux/issues/502
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
