From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: found __[us]{8,16,32,64} type without #include <linux/types.h>
Date: Fri, 9 Sep 2011 16:29:52 +0200
Message-ID: <201109091629.52879.arnd@arndb.de>
References: <m3vct1u75k.fsf@jhcloos.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m3vct1u75k.fsf@jhcloos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mm@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-scsi@vger.kernel.org

On Friday 09 September 2011, James Cloos wrote:
> All noticed while compiling 3.1-r5:
> 
> linux/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

This has been around for a long time, I think. I agree that we should do
something about it, but I think we're still looking for a solution that
makes everyone happy.

The script only checks for direct inclusions of types.h, while the drm headers
get it from drm.h. One solution would be to make the script smart enough
to evaluate all indirect header inclusions as well. A more hacky workaround
would be to just treat "drm.h" the same as <linux/types.h>.

	Arnd
