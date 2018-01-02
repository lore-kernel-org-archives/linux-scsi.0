From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RFC] sg3_utils: sgp_dd: work around on pthread_cancel for
 android
Date: Tue, 2 Jan 2018 08:40:48 -0800
Message-ID: <b406b487-3d4b-18a3-5fde-bd4d2617292d@wdc.com>
References: <c392b57894184572bd1285be32f4a27f@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40699 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeABQks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 11:40:48 -0500
In-Reply-To: <c392b57894184572bd1285be32f4a27f@SIWEX5A.sing.micron.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>

On 12/26/17 14:21, Bean Huo (beanhuo) wrote:
>My changes are below:
> 
> Configure.ac:
> +# check for pthread_cancel
> +AC_SEARCH_LIBS(pthread_cancel, pthread,
> +     [AC_DEFINE(HAVE_PTHREAD_CANCEL, 1, [have pthread_cancel])], [], [])
> 
> Src/Makefile.am
> -sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ -lpthread
> +sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ @LIBS@
> 
> In the Src/sgp_dd.c, I can use macro definition " HAVE_PTHREAD_CANCEL" to differentiate
> pthread_cancel supports or not.
> 
> It works.
> But I got one warning below while run autoreconf , do you know what is wrong with that?
> configure.ac:15: warning: AC_PROG_LIBTOOL was called before AM_PROG_AR
> configure.ac:15: warning: LT_INIT was called before AM_PROG_AR

Hello Bean,

Even if these warnings would get addressed, we still would need 
something like the following change for src/sgp_dd.c:

diff --git a/src/sgp_dd.c b/src/sgp_dd.c
--- a/src/sgp_dd.c
+++ b/src/sgp_dd.c
@@ -181,6 +181,7 @@ static int sg_finish_io(bool wr, Rq_elem * rep,

  static pthread_mutex_t strerr_mut = PTHREAD_MUTEX_INITIALIZER;

+static bool shutting_down = false;
  static bool do_sync = false;
  static bool do_time = false;
  static Rq_coll rcoll;
@@ -470,6 +471,8 @@ sig_listen_thread(void * v_clp)

      while (1) {
          sigwait(&signal_set, &sig_number);
+        if (shutting_down)
+                break;
          if (SIGINT == sig_number) {
              pr2serr(ME "interrupted by SIGINT\n");
              guarded_stop_both(clp);
@@ -1629,8 +1632,10 @@ main(int argc, char * argv[])
          }
      }

-    status = pthread_cancel(sig_listen_thread_id);
-    if (0 != status) err_exit(status, "pthread_cancel");
+    shutting_down = true;
+
+    status = pthread_kill(sig_listen_thread_id, SIGINT);
+    if (0 != status) err_exit(status, "pthread_kill");
      if (STDIN_FILENO != rcoll.infd)
          close(rcoll.infd);

My proposal is to leave out any ifdef HAVE_PTHREAD_CANCEL tests and to 
use pthread_kill() on all platforms. Since sgp_dd is the only tool that 
uses pthread_cancel() this approach will allow to leave out the 
pthread_cancel() configure test. I'm proposing this approach because it 
will make it easier to maintain and to test the sgp_dd tool.

Thanks,

Bart.
