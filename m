From: "Salyzyn, Mark" <mark_salyzyn-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4
Date: Wed, 7 Jan 2004 15:12:44 -0500
Sender: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
Message-ID: <C2CB6D8BA015124783C0EB9B33D24FFD047F90@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org>
Errors-To: linux-aacraid-devel-admin-8PEkshWhKlo@public.gmane.org
List-Help: <mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJuMTnGGMi8c9@public.gmane.org>
List-Post: <mailto:linux-aacraid-devel-8PEkshWhKlo@public.gmane.org>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJhLjRD9WNpgrmSKB9SHqsyg@public.gmane.org>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel>,
	<mailto:linux-aacraid-devel-request-8PEkshWhKlpvbvzxeQLTJt/CJOUnrhF+9vnX9k1QryA@public.gmane.org>
List-Archive: <http://lists.us.dell.com/pipermail/linux-aacraid-devel/>
To: 'Arjan van de Ven' <arjanv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Xose Vazquez Perez' <xose-39ZsbGIQGT7e5aOfsHch1g@public.gmane.org>
Cc: "'linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org'" <linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org>, 'linux-scsi' <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Responses (defenses?) embedded below preceded by an `mgs>'

Sincererly -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Arjan van de Ven
Sent: Wednesday, January 07, 2004 1:42 PM
To: Xose Vazquez Perez
Cc: linux-aacraid-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org; linux-scsi
Subject: Re: [PATCH] 1.1.4-2313 aacraid driver for LiNUX 2.4.25-pre4

On Wed, Jan 07, 2004 at 07:28:01PM +0100, Xose Vazquez Perez wrote:
> hi,
> 
> here goes latest aacraid driver, it was sent for 2.4 kernel
> inclusion. CHANGELOG has an extensive list of changes.

+#define aac_spin_lock_irqsave(host_lock, cpu_flags)
spin_lock_irqsave(&io_request_lock, cpu_flags)
+#define aac_spin_lock_irq(host_lock)
spin_lock_irq(&io_request_lock)
+#define aac_spin_unlock_irqrestore(host_lock, cpu_flags)
spin_unlock_irqrestore(&io_request_lock, cpu_flags)
+#define aac_spin_unlock_irq(host_lock)
spin_unlock_irq(&io_request_lock)
 

ewwww

mgs> In Adaptec's version of the code, this is part of a kernel versioning
mgs> ifdef, to use the `host_lock' passed in, or the io_request_lock global
mgs> Better here than at each locale. However, I think I chose the wrong
mgs> side of the ifdef, doesn't 2.4.25-pre4 use host->host_lock?


+#ifdef AAC_DETAILED_STATUS_INFO
 static char *aac_get_status_string(u32 status);
+#endif

there's no need for ifdefs around prototypes, they just clutter the code

mgs> Okely Dokely

+        *      Only enable DAC mode if the dma_addr_t is larger than 32
+        * bit addressing, and we have more than 32 bit addressing worth of
+        * memory and if the controller supports 64 bit scatter gather
elements.
+        */
+       if( (sizeof(dma_addr_t) > 4) && (num_physpages > (0xFFFFFFFFULL >>
PAGE_SHIFT)) && (dev->adapter_info.options &
+               dev->dac_support = 1;
        }

that looks broken, at least drivers should never need to check num_physpages
etc etc

mgs> If the system has less than 4G of memory, it is in the interest of
mgs> performance to use the 32 bit variants of the adapter packets. Smaller
mgs> frames, and capable of a larger number of scatter-gather elements.

+static void get_sd_devname(int disknum, char *buffer)
+{
+.....


why on earth is that in a driver?????

mgs> The management tools issue ioctls to query for the information. RAID
mgs> drivers require management tool support.

+# define strlcpy(s1,s2,n) strncpy(s1,s2,n);s1[n-1]='\0'


this is very broken; consider

if (foo)
    bar(foo);
else
    strlcpy(foo,bar,3);

mgs> this is `good enough' for the driver, s1 in the driver context is
mgs> not a value of null.

+# ifndef min
+#  define min(a,b) (((a)<(b))?(a):(b))
+# endif

that is quite broken..... arguments get evaluated multiple times

mgs> This is in here for compatibility reasons (should be in compat.h),
mgs> could be dropped as min is defined by the include framework. This
mgs> `minimal' definition is good enough for the driver since locally
mgs> both a and b are `constants'.

 struct fib_ioctl
 {
-       char    *fibctx;
-       int     wait;
-       char    *fib;
+       u32     fibctx;
+       s32     wait;
+#if (defined(__x86_64__))
+       u64     fib;
+#else
+       u32     fib;
+#endif
 };


that looks really fishy; __x86_64__ most certainly is not the only 64 bit
architecture out there

mgs> Only the __x86_64__ architecture has the register_ioctl32_conversion
mgs> handler. This is reflection of what has been tested with the currently
mgs> available management tools. The only 64 bit architecture that has
mgs> the management tools compiled as a 64 bit applications is for the AMD64
mgs> right now. I have not yet determined how to figure out if a 32 bit
mgs> legacy app or a 64 bit updated app has issued the ioctl call to the
mgs> driver under other architectures.

this driver "update" appears to intruduce quite a few nastys... doesn't look
like a good idea to me

mgs> Throwing the baby out with the bathwater? ;-/ I *know* that a bunch of
mgs> small updates would be easier to swallow, but alas the aacraid driver
mgs> in the 2.4 tree has been neglected for some time. Being at the front
mgs> line at Adaptec for bug reports against this driver, I would hope that
mgs> I would acquire a critical response and then tailor a more refined
mgs> meta-patch later.

_______________________________________________
Linux-aacraid-devel mailing list
Linux-aacraid-devel-8PEkshWhKlo@public.gmane.org
http://lists.us.dell.com/mailman/listinfo/linux-aacraid-devel
Please read the FAQ at http://lists.us.dell.com/faq or search the list archives at http://lists.us.dell.com/htdig/
