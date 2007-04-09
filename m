From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [BUG] unable to handle kernel paging request at virtual address
 0800000e
Date: Mon, 09 Apr 2007 16:48:01 -0400
Message-ID: <461AA681.50605@redhat.com>
References: <4616CBF4.8020205@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965393AbXDIUsU@vger.kernel.org>
In-Reply-To: <4616CBF4.8020205@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thomas Meyer wrote:
> dmesg output:
> 
> pktcdvd: pkt_get_last_written failed
> BUG: unable to handle kernel paging request at virtual address 0800000e
<SNIP>
> EFLAGS: 00010203   (2.6.21-rc6 #295)
<SNIP>
> cdrom: This disc doesn't have any tracks I recognize!
> 
> This happens while calling command pktsetup.
> 

Well that's very strange.

long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
{
        char *tmp = getname(filename);
        int fd = PTR_ERR(tmp);

        if (!IS_ERR(tmp)) {
                fd = get_unused_fd();
                if (fd >= 0) {
============>           struct file *f = do_filp_open(dfd, tmp, flags, mode);
                        if (IS_ERR(f)) {
                                put_unused_fd(fd);
                                fd = PTR_ERR(f);
                        } else {
                                fsnotify_open(f->f_path.dentry);
                                fd_install(fd, f);
                        }
                }
                putname(tmp);
        }

do_filp_open has returned 0x8000002

Isn't that a SCSI error of some kind?

IAC we have tried to do fsnotify_open(f->f_path.dentry) with that result...
