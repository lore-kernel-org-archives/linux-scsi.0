From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 3/3] PM: Limit race conditions between
 runtime PM and system sleep
Date: Tue, 28 Jun 2011 23:56:43 +0800
Message-ID: <20110628235643.4cf7cff0@tom-ThinkPad-T410>
References: <201106260054.20578.rjw@sisk.pl> <201106260056.32221.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <201106260056.32221.rjw@sisk.pl>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


Hi Rafael,

On Sun, 26 Jun 2011 00:56:31 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Index: linux-2.6/Documentation/power/runtime_pm.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/runtime_pm.txt
> +++ linux-2.6/Documentation/power/runtime_pm.txt
> @@ -567,6 +567,11 @@ this is:
>  	pm_runtime_set_active(dev);
>  	pm_runtime_enable(dev);
>  
> +The PM core always increments the run-time usage counter before calling the
> +->suspend() callback and decrements it after calling the ->resume() callback.
> +Hence disabling run-time PM temporarily like this will not cause any run-time
> +suspend callbacks to be lost.

Could you explain why the above is that "this will not cause any run-time suspend
callbacks to be lost"? 

Looks like it should be "this will not cause any run-time suspend callbacks to
be called", but not sure.


thanks,
-- 
Ming Lei
